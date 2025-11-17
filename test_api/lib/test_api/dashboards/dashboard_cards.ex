defmodule TestApi.Dashboards.DashboardCards do
  alias TestApi.Repo
  alias TestApi.Dashboards.DashboardCard
  require Logger
  def list_dashboard_cards do
    Repo.all(DashboardCard)
  end
  def get_dashboard_card!(id), do: Repo.get!(DashboardCard, id)
  def get_dashboard_card(id) do
    case Repo.get(DashboardCard, id) do
      nil -> {:error, :not_found}
      dashboard_card -> {:ok, dashboard_card}

    end

  end
  def create_dashboard_card(attrs) do
    %DashboardCard{}
    |> DashboardCard.changeset(attrs)
    |> Repo.insert()
  end
  def delete_dashboard_card(id) do
    dashboard_card = get_dashboard_card!(id)
    Repo.delete(dashboard_card)
  end
end
