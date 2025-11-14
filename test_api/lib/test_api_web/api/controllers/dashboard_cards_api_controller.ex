defmodule TestApiWeb.Api.DashboardCardApiController do
  use TestApiWeb, :controller
  alias TestApi.Dashboards.DashboardCard
  alias TestApi.Repo
  require Logger
  def index(conn, _params) do
    dashboard_cards = Repo.all(DashboardCard)
    Logger.info("Dashboard cards fetched successfully")
    conn
    |> put_status(:ok)
    |> json(%{data: dashboard_cards})
  end
  def show(conn, %{"id" => id}) do
    case Repo.get(DashboardCard, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Dashboard card not found with id: #{id}"})
        dashboard_card ->
          Logger.info("specific dashboard card fetched success with id: #{id}")
          conn
          |> put_status(:ok)
          |> json(%{data: dashboard_card})

    end
  end
    def create(conn, %{"dashboard_card" => dashboard_card_params}) do
      changeset = DashboardCard.changeset(%DashboardCard{}, dashboard_card_params)
      case Repo.insert(changeset) do
        {:ok, dashboard_card} ->
          Logger.info("Dashboard card created successfully with id: #{dashboard_card.id}")
          conn
          |> put_status(:created)
          |> json(%{data: dashboard_card})
          {:error, changeset} ->
            Logger.warn("Failed to create card for dashboard: #{inspect(changeset.errors)}")
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: changeset.errors})

    end
  end
end
