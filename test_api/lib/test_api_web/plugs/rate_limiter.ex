defmodule TestApiWeb.Plugs.RateLimiter do
  import Plug.Conn
  require Logger

  @table_name :rate_limiter
  @default_limit 100
  @default_window 60_000

  def init(opts) do
    limit = Keyword.get(opts, :limit, @default_limit)
    window = Keyword.get(opts, :window, @default_window)
    %{limit: limit, window: window}
  end

  def call(conn, %{limit: limit, window: window}) do
    ip = get_client_ip(conn)
    key = {ip, current_window(window)}

    case check_rate_limit(key, limit) do
      {:ok, count} ->
        conn
        |> put_resp_header("x-ratelimit-limit", to_string(limit))
        |> put_resp_header("x-ratelimit-remaining", to_string(max(0, limit - count)))
        |> put_resp_header("x-ratelimit-reset", to_string(reset_time(window)))

      {:error, :rate_limit_exceeded, count} ->
        Logger.warning("Rate limit exceeded for IP: #{inspect(ip)}, count: #{count}")

        conn
        |> put_status(:too_many_requests)
        |> put_resp_content_type("application/json")
        |> put_resp_header("x-ratelimit-limit", to_string(limit))
        |> put_resp_header("x-ratelimit-remaining", "0")
        |> put_resp_header("x-ratelimit-reset", to_string(reset_time(window)))
        |> put_resp_header("retry-after", to_string(calculate_retry_after(window)))
        |> send_resp(429, Jason.encode!(%{
          error: %{
            status: 429,
            message: "Too Many Requests",
            detail: "Rate limit exceeded. Please try again later.",
            retry_after: calculate_retry_after(window)
          }
        }))
        |> halt()
    end
  end

  defp get_client_ip(conn) do
    case get_req_header(conn, "x-forwarded-for") do
      [ip | _] -> String.split(ip, ",") |> List.first() |> String.trim()
      [] -> to_string(:inet_parse.ntoa(conn.remote_ip))
    end
  end

  defp current_window(window) do
    System.system_time(:millisecond) |> div(window)
  end

  defp reset_time(window) do
    current_window(window) * window + window
  end

  defp calculate_retry_after(window) do
    now = System.system_time(:millisecond)
    reset = reset_time(window)
    max(1, div(reset - now, 1000))
  end

  defp check_rate_limit(key, limit) do
    ensure_table_exists()

    case :ets.update_counter(@table_name, key, 1, {key, 0}) do
      count when count <= limit -> {:ok, count}
      count -> {:error, :rate_limit_exceeded, count}
    end
  end

  defp ensure_table_exists do
    case :ets.whereis(@table_name) do
      :undefined ->
        :ets.new(@table_name, [:named_table, :public, :set, write_concurrency: true])
        :ok

      _pid ->
        :ok
    end
  end
end
