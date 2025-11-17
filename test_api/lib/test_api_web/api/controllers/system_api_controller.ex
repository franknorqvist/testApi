defmodule TestApiWeb.Api.SystemApiController do
  use TestApiWeb, :controller
  alias TestApi.Systems.Systems
  require Logger
  def index(conn, _params) do
    systems = Systems.list_systems()
    Logger.info("Companies fetched successfully")

    conn
    |> put_status(:ok)
    |> json(%{data: systems})

  end

  def show(conn, %{"id" => id}) do
    case Systems.get_system(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Company not found with id: #{id}"})

        system ->
          Logger.info("Company fetched successfully with id: #{id}")
          conn
          |> put_status(:ok)
          |> json(%{data: system})

    end
  end

  def delete(conn, %{"id" => id}) do
    Systems.delete_system(id)

    json(conn, %{message: "Company deleted successfully"})
  end

  def create(conn, %{"system" => system_params}) do
case Systems.create_system(system_params) do
  {:ok, system} ->
    Logger.info("System created successfully with id: #{system.id}")
    conn
    |> put_status(:created)
    |> json(%{data: system})

    {:error, changeset} ->
      Logger.warn("Failed to create system: #{inspect(changeset.errors)}")
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{errors: changeset.errors})
end
  end
end
