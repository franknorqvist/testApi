defmodule TestApiWeb.Api.UserApiController do
  use TestApiWeb, :controller

  alias TestApi.Users.Users
  action_fallback TestApiWeb.Api.FallbackController
  require Logger

  def index(conn, _params) do
    users = Users.list_users()
    Logger.info("Users fetched successfully")

    conn
    |> put_status(:ok)
    |> json(%{data: users})
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Users.get_user(id) do
      Logger.info("User fetched successfully with id: #{id}")
      conn
      |> put_status(:ok)
      |> json(%{data: user})
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Users.create_user(user_params) do
      Logger.info("User created successfully with id: #{user.id}")
      conn
      |> put_status(:created)
      |> json(%{data: user})
    end
  end
end
