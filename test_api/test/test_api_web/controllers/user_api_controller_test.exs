defmodule TestApiWeb.Api.UserApiControllerTest do
  use TestApiWeb.ConnCase
  alias TestApi.Repo
  alias TestApi.Users.User
  import TestApi.Fixtures

  describe "Get /api/users" do
    test "list all users", %{conn: conn} do
      user1 = user_fixture(%{name: "User 1", system_id: system_fixture().id})
      user2 = user_fixture(%{name: "User 2", system_id: system_fixture().id})
      conn = get(conn, ~p"/api/users")
      assert %{
        "data" => [
          %{"id" => id1, "name" => "User 1"},
          %{"id" => id2, "name" => "User 2"}
        ]
      } = json_response(conn, 200)
      assert id1 == user1.id
      assert id2 == user2.id
    end
    test "return empty list if no users exist", %{conn: conn} do
      conn = get(conn, ~p"/api/users" )
      assert %{"data" => []} = json_response(conn, 200)
    end
  end

  describe "Get /api/users/:id" do
    test "show user when id is valid", %{conn: conn} do
      user = user_fixture(%{name: "Test User"})
      conn = get(conn, ~p"/api/users/#{user.id}")
      assert %{
        "data" => %{
          "id" => id,
          "name" => "Test User",
          "system_id" => system_id
        }
      } = json_response(conn, 200)
      assert id == user.id
    end
    test "return 404 if user does not exist", %{conn: conn} do
      conn = get(conn, ~p"/api/users/99999")
      assert %{
        "error" => %{
          "status" => 404,
          "message" => "Not Found"
        }
      } = json_response(conn, 404)
    end
  end


  describe "POST /api/users" do
    test "creates user with valid data", %{conn: conn} do
      system = system_fixture()

      conn =
        post(conn, ~p"/api/users", %{
          "user" => %{
            "name" => "New User",
            "system_id" => system.id
          }
        })

      assert %{
        "data" => %{
          "id" => _id,
          "name" => "New User",
          "system_id" => system_id
        }
      } = json_response(conn, 201)

      assert system_id == system.id
    end

    test "returns 422 when name is too short", %{conn: conn} do
      system = system_fixture()

      conn =
        post(conn, ~p"/api/users", %{
          "user" => %{
            "name" => "AB",
            "system_id" => system.id
          }
        })

      assert %{
        "error" => %{
          "status" => 422,
          "message" => "Unprocessable Entity"
        }
      } = json_response(conn, 422)
    end

    test "returns 422 when name is missing", %{conn: conn} do
      system = system_fixture()

      conn =
        post(conn, ~p"/api/users", %{
          "user" => %{
            "system_id" => system.id
          }
        })

      assert %{
        "error" => %{
          "status" => 422,
          "message" => "Unprocessable Entity"
        }
      } = json_response(conn, 422)
    end

    test "returns 422 when system_id is invalid", %{conn: conn} do
      conn =
        post(conn, ~p"/api/users", %{
          "user" => %{
            "name" => "New User",
            "system_id" => 999999
          }
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
