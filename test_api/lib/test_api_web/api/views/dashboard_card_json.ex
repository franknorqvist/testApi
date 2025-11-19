defmodule TestApiWeb.Api.DashboardCardApiJSON do
  alias TestApi.Dashboards.DashboardCard

  def render("index.json", %{dashboard_cards: dashboard_cards}) do
    %{data: Enum.map(dashboard_cards, &render("dashboard_card.json", %{dashboard_card: &1}))}
  end

  def render("show.json", %{dashboard_card: dashboard_card}) do
    %{data: render("dashboard_card.json", %{dashboard_card: dashboard_card})}
  end

  def render("create.json", %{dashboard_card: dashboard_card}) do
    %{data: render("dashboard_card.json", %{dashboard_card: dashboard_card})}
  end

  def render("dashboard_card.json", %{dashboard_card: dashboard_card}) do
    %{
      id: dashboard_card.id,
      x: dashboard_card.x,
      y: dashboard_card.y,
      w: dashboard_card.w,
      h: dashboard_card.h,
      system_id: dashboard_card.system_id,
      dashboard_id: dashboard_card.dashboard_id,
      inserted_at: dashboard_card.inserted_at,
      updated_at: dashboard_card.updated_at
    }
  end
end
