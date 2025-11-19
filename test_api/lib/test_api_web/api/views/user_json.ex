defmodule TestApiWeb.Api.UserApiJSON do
  alias TestApi.Users.User

  def render("index.json", %{users: users}) do
    %{data: Enum.map(users, &render("user.json", %{user: &1}))}
  end

  def render("show.json", %{user: user}) do
    %{data: render("user.json", %{user: user})}
  end

  def render("create.json", %{user: user}) do
    %{data: render("user.json", %{user: user})}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      system_id: user.system_id,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
