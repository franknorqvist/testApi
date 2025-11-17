defmodule TestApiWeb.Api.UserApiController do
  use TestApiWeb, :controller
  alias TestApi.Users.Users
  require Logger

  def index(conn, _params) do
    users = Users.list_users()
    Logger.info("Users fetched successfully")
    conn
    |> put_status(:ok)
    |> json(%{data: users})
  end
  def show(conn, %{"id" => id}) do
    case Users.get_user(id) do
      {:ok, user} ->
        Logger.info("User fetched successfully with id: #{id}")
        conn
        |> put_status(:ok)
        |> json(%{data: user})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found with id: #{id}"})
    end
  end
  def create(conn, %{"user" => user_params}) do


    case Users.create_user(user_params) do
      {:ok, user} ->
        Logger.info("User created successfully with id: #{user.id}")
        conn
        |> put_status(:created)
        |> json(%{data: user})

      {:error, changeset} ->
        Logger.warn("Failed to create user: #{inspect(changeset.errors)}")

        # Kolla om felet är relaterat till system_id
        error_message =
          if changeset.errors[:system_id] do
            "Invalid system_id or system does not exist"
          else
            translate_errors(changeset)
          end

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: error_message})
    end
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
