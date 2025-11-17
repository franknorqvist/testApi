defmodule TestApiWeb.Api.Controllers.FallbackController do
  use TestApiWeb, :controller
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: TestApiWeb.ErrorJSON)
    |> render(:"404")
  end
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: TestApiWeb.ErrorJSON)
    |> render(:"422", changeset: changeset)
  end

end
