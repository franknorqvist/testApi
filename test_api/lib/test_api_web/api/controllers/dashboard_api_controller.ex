defmodule TestApiWeb.Api.DashboardApiController do
  use TestApiWeb, :controller

  alias TestApi.Dashboards.Dashboards
  require Logger

  def index(conn, _params) do
    dashboards = Dashboards.list_dashboards()
    Logger.info("Dashboards fetched successfully")

    conn
    |> put_status(:ok)
    |> json(%{data: dashboards})
  end

  def show(conn, %{"id" => id}) do
    case Dashboards.get_dashboard_with_cards(id) do
      {:ok, dashboard, dashboard_cards} ->
        Logger.info("Dashboard fetched successfully with id: #{id}")
        conn
        |> put_status(:ok)
        |> json(%{dashboard: dashboard, dashboard_cards: dashboard_cards})

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Dashboard not found with id: #{id}"})
    end
  end

  def create(conn, %{"dashboard" => dashboard_params}) do
    case Dashboards.create_dashboard(dashboard_params) do
      {:ok, dashboard} ->
        Logger.info("Dashboard created successfully with id #{dashboard.id}")
        conn
        |> put_status(:created)
        |> json(%{data: dashboard})

      {:error, changeset} ->
        Logger.warn("Failed to create dashboard: #{inspect(changeset.errors)}")
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end
end
