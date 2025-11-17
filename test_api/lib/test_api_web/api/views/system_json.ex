defmodule TestApiWeb.Api.SystemApiJSON do
  alias TestApi.Systems.System

  def render("index.json", %{systems: systems}) do
    %{data: Enum.map(systems, &render("system.json", %{system: &1}))}
  end

  def render("show.json", %{system: system}) do
    %{data: render("system.json", %{system: system})}
  end

  def render("create.json", %{system: system}) do
    %{data: render("system.json", %{system: system})}
  end

  def render("system.json", %{system: system}) do
    %{
      id: system.id,
      name: system.name,
      inserted_at: system.inserted_at,
      updated_at: system.updated_at
    }
  end
end
