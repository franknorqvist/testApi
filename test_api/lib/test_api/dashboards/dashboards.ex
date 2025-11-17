defmodule TestApi.Dashboards.Dashboards do
  import Ecto.Query
  alias TestApi.Repo
  alias TestApi.Dashboards.Dashboard
  alias TestApi.Dashboards.DashboardCard
  require Logger
  def list_dashboards do
    Repo.all(Dashboard)
  end
  def get_dashboard(id), do: Repo.get!(Dashboard, id)
  def get_dashboard!(id) do
    case Repo.get(Dashboard, id) do
      nil -> {:error, :not_found}
      dashboard -> {:ok, dashboard}

    end
  end
  def create_dashboard(attrs) do
    %Dashboard{}
    |> Dashboard.changeset(attrs)
    |> Repo.insert()

  end
  def get_dashboard_with_cards(id) do
    case Repo.get(Dashboard, id) do
      nil -> {:error, :not_found}
      dashboard ->
        dashboard_cards = DashboardCard
        |> where(dashboard_id: ^dashboard.id)
        |> Repo.all()
        {:ok, dashboard, dashboard_cards}
    end
  end

  def delete_dashboard(id) do
    dashboard = get_dashboard!(id)
    Repo.delete(dashboard)

  end

end
