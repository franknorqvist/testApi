defmodule TestApiWeb.Api.SystemApiController do
  use TestApiWeb, :controller
 alias TestApiWeb.Api.Views.SystemJson
  alias TestApi.Systems.Systems
  action_fallback TestApiWeb.Api.FallbackController
  require Logger

  def index(conn, _params) do
    systems = Systems.list_systems()
    Logger.info("Companies fetched successfully")

    conn
    |> put_status(:ok)
    |> render(:index, systems: systems)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, system} <- Systems.get_system(id) do
      Logger.info("Company fetched successfully with id: #{id}")
      conn
      |> put_status(:ok)
      |> render(:show, system: system)
    end
  end

  def delete(conn, %{"id" => id}) do
    Systems.delete_system(id)

    conn
    |> put_status(:ok)
    |> json(%{message: "Company deleted successfully"})
  end

  def create(conn, %{"system" => system_params}) do
    with {:ok, system} <- Systems.create_system(system_params) do
      Logger.info("System created successfully with id: #{system.id}")
      conn
      |> put_status(:created)
      |> render(:create, system: system)
    end
  end
end
