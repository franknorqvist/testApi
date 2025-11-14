defmodule TestApiWeb.Api.DashboardApiController do

  use TestApiWeb, :controller
  import Ecto.Query
  alias TestApi.Dashboards.Dashboard
  alias TestApi.Dashboards.DashboardCard
  alias TestApi.Repo
  alias TestApi.Systems.System
  alias TestApi.Users.User
  require Logger


  def index(conn, _params) do
    dashboards = Repo.all(Dashboard)
    Logger.info("Dashboards fetched successfully")
    conn
    |> put_status(:ok)
    |> json(%{data: dashboards})

  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Dashboard, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Dashboard not found with id: #{id}"})
          dashboard ->
            dashboard_cards = DashboardCard |> where(dashboard_id: ^dashboard.id) |> Repo.all()

            Logger.info("Dashboard fetched succesfully with id: #{id}")
            conn
            |> put_status(:ok)
            |> json(%{dashboard: dashboard, dashboard_cards: dashboard_cards})

    end

  end

  def create(conn, %{"dashboard" => dashboard_params}) do
    changeset = Dashboard.changeset(%Dashboard{}, dashboard_params)

    case Repo.insert(changeset) do
      {:ok, dashboard} ->
        Logger.info("Dashboard created succesfully with id #{dashboard.id}")
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
