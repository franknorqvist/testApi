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
    |> render(:index, users: users)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Users.get_user(id) do
      Logger.info("User fetched successfully with id: #{id}")
      conn
      |> put_status(:ok)
      |> render(:show, user: user)
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Users.create_user(user_params) do
      Logger.info("User created successfully with id: #{user.id}")
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end
end
