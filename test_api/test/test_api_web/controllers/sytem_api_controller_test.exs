defmodule TestApiWeb.Api.SystemApiControllerTest do
use TestApiWeb.ConnCase
alias TestApi.Repo
alias TestApi.Systems.System
import TestApi.Fixtures

describe "GET /api/systems" do
  test "lists all systems", %{conn: conn} do
    system1 = system_fixture(%{name: "System 1"})
    system2 = system_fixture(%{name: "System 2"})

    conn = get(conn, ~p"/api/systems")

    assert %{
      "data" => [
        %{"id" => id1, "name" => "System 1"},
        %{"id" => id2, "name" => "System 2"}
      ]
    } = json_response(conn, 200)

    assert id1 == system1.id
    assert id2 == system2.id
  end

  test "returns empty list when no systems exist", %{conn: conn} do
    conn = get(conn, ~p"/api/systems")

    assert %{"data" => []} = json_response(conn, 200)
  end
end

describe "GET /api/systems/:id" do
  test "shows system when id is valid", %{conn: conn} do
    system = system_fixture(%{name: "Test System"})

    conn = get(conn, ~p"/api/systems/#{system.id}")

    assert %{
      "data" => %{
        "id" => id,
        "name" => "Test System"
      }
    } = json_response(conn, 200)

    assert id == system.id
  end

  test "returns 404 when system does not exist", %{conn: conn} do
    conn = get(conn, ~p"/api/systems/999999")

    assert %{
      "error" => %{
        "status" => 404,
        "message" => "Not Found"
      }
    } = json_response(conn, 404)
  end
end
describe "POST /api/systems" do
  test "creates system with valid data", %{conn: conn} do
    conn =
      post(conn, ~p"/api/systems", %{
        "system" => %{"name" => "New System"}
      })

    assert %{
      "data" => %{
        "id" => _id,
        "name" => "New System"
      }
    } = json_response(conn, 201)
  end

  test "returns 422 when name is too short", %{conn: conn} do
    conn =
      post(conn, ~p"/api/systems", %{
        "system" => %{"name" => "AB"}
      })

    assert %{
      "error" => %{
        "status" => 422,
        "message" => "Unprocessable Entity"
      }
    } = json_response(conn, 422)
  end

  test "returns 422 when name is missing", %{conn: conn} do
    conn =
      post(conn, ~p"/api/systems", %{
        "system" => %{}
      })

    assert %{
      "error" => %{
        "status" => 422,
        "message" => "Unprocessable Entity"
      }
    } = json_response(conn, 422)
  end
end
end
