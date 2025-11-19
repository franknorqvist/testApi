defmodule TestApiWeb.Api.DashboardApiJSON do
  alias TestApi.Dashboards.Dashboard
  alias TestApiWeb.Api.DashboardCardApiJSON

  def render("index.json", %{dashboards: dashboards}) do
    %{data: Enum.map(dashboards, &render("dashboard.json", %{dashboard: &1}))}
  end

  def render("show.json", %{dashboard: dashboard, dashboard_cards: dashboard_cards}) do
    %{
      dashboard:
        render("dashboard.json", %{
          dashboard: dashboard,
          dashboard_cards: dashboard_cards
        })
    }
  end

  def render("dashboard.json", %{dashboard: dashboard, dashboard_cards: dashboard_cards}) do
    %{
      id: dashboard.id,
      name: dashboard.name,
      system_id: dashboard.system_id,
      user_id: dashboard.user_id,
      inserted_at: dashboard.inserted_at,
      updated_at: dashboard.updated_at,
      dashboard_cards:
        Enum.map(
          dashboard_cards,
          &DashboardCardApiJSON.render("dashboard_card.json", %{dashboard_card: &1})
        )
    }
  end

  def render("dashboard.json", %{dashboard: dashboard}) do
    %{
      id: dashboard.id,
      name: dashboard.name,
      system_id: dashboard.system_id,
      user_id: dashboard.user_id,
      inserted_at: dashboard.inserted_at,
      updated_at: dashboard.updated_at
    }
  end
end
