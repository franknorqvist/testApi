defmodule TestApiWeb.Api.DashboardApiController do
  use TestApiWeb, :controller

  alias TestApi.Dashboards.Dashboards
  action_fallback TestApiWeb.Api.FallbackController

  def index(conn, _params) do
    dashboards = Dashboards.list_dashboards()

    conn
    |> put_status(:ok)
    |> render(:index, dashboards: dashboards)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, dashboard, dashboard_cards} <- Dashboards.get_dashboard_with_cards(id) do
      conn
      |> put_status(:ok)
      |> render(:show, dashboard: dashboard, dashboard_cards: dashboard_cards)
    end
  end

  def create(conn, %{"dashboard" => dashboard_params}) do
    with {:ok, dashboard} <- Dashboards.create_dashboard(dashboard_params) do
      conn
      |> put_status(:created)
      |> render(:show, dashboard: dashboard, dashboard_cards: [])  # ✅ dashboard (singular)
    end
  end
end
