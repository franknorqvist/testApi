defmodule TestApiWeb.Api.FallbackController do
  use TestApiWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: TestApiWeb.Api.ErrorApiJSON)
    |> render(:"404", message: "The requested resource could not be found")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: TestApiWeb.Api.ErrorApiJSON)
    |> render(:"422", changeset: changeset)
  end
end
