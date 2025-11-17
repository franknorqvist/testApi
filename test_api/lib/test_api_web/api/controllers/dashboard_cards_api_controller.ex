defmodule TestApiWeb.Api.DashboardCardApiController do
  use TestApiWeb, :controller
  alias TestApi.Dashboards.DashboardCards
  action_fallback TestApiWeb.Api.FallbackController
  require Logger
  def index(conn, _params) do
    dashboard_cards = DashboardCards.list_dashboard_cards()
    Logger.info("Dashboard cards fetched successfully")
    conn
    |> put_status(:ok)
    |> json(%{data: dashboard_cards})
  end
  def show(conn, %{"id" => id}) do
with {:ok, dashboard_card}  <- DashboardCards.get_dashboard_card(id) do
          Logger.info("specific dashboard card fetched success with id: #{id}")
          conn
          |> put_status(:ok)
          |> json(%{data: dashboard_card})

    end
  end
    def create(conn, %{"dashboard_card" => dashboard_card_params}) do
      with {:ok, dashboard_card} <- DashboardCards.create_dashboard_card(dashboard_card_params) do
        Logger.info("Dashboard card created with id: #{dashboard_card.id}")
            conn
            |> put_status(:created)
            |> json(%{data: dashboard_card})
    end
  end
end
