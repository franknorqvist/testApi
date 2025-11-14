defmodule TestApiWeb.Api.SystemApiController do
  use TestApiWeb, :controller

  alias TestApi.Systems.System
  alias TestApi.Repo
  require Logger
  def index(conn, _params) do
    systems = Repo.all(System)
    Logger.info("Companies fetched successfully")

    conn
    |> put_status(:ok)
    |> json(%{data: systems})

  end

  def show(conn, %{"id" => id}) do
    case Repo.get(System, id) do
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
    system = Repo.get!(System, id)
    Repo.delete!(system)
    json(conn, %{message: "Company deleted successfully"})
  end

  def create(conn, %{"system" => system_params}) do
    changeset = System.changeset(%System{}, system_params)
    {:ok, system} = Repo.insert(changeset)

    conn
    |> put_status(:created)
    |> json(%{data: system})
  end
end
