defmodule TestApi.Fixtures do
  alias TestApi.Repo
  alias TestApi.Systems.System
  alias TestApi.Users.User
  alias TestApi.Dashboards.Dashboard
  alias TestApi.Dashboards.DashboardCard

  def system_fixture(attrs \\ %{}) do
    {:ok, system} =
      attrs
      |> Enum.into(%{
        name: "Test System #{:erlang.unique_integer([:positive])}"
      })
      |> then(fn attrs ->
        %System{}
        |> System.changeset(attrs)
        |> Repo.insert()
      end)

    system
  end
  def user_fixture(attrs \\ %{}) do
    system_id = Map.get_lazy(attrs, :system_id, fn -> system_fixture().id end)
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Test Users #{:erlang.unique_integer([:positive])}",
       system_id: system_id
    })
    |> then(fn attrs ->
      %User{}
      |> User.changeset(attrs)
      |> Repo.insert()
    end)

      user
    end


    def dashboard_fixture(attrs \\ %{}) do
      system = Map.get_lazy(attrs, :system_id, fn -> system_fixture() end)
      user = Map.get_lazy(attrs, :user_id, fn -> user_fixture() end)
      {:ok, dashboard} =
        attrs
        |> Enum.into(%{
          name: "Test Dashboards #{:erlang.unique_integer([:positive])}",
          system_id: system,
          user_id: user
        })
        |> then(fn attrs ->
          %Dashboard{}
          |> Dashboard.changeset(attrs)
          |> Repo.insert()
        end)
        dashboard
    end
     def dashboard_card_fixture(attrs \\ %{}) do
      system = Map.get_lazy(attrs, :system_id, fn -> system_fixture() end)
      dashboard = Map.get_lazy(attrs, :dashboard_id, fn -> dashboard_fixture() end)
      {:ok, card} =
        attrs
        |> Enum.into(%{
          x: 0,
          y: 0,
          w: 1,
          h: 1,
          system_id: system,
          dashboard_id: dashboard
        })
        |> then(fn attrs ->
          %DashboardCard{}
          |> DashboardCard.changeset(attrs)
          |> Repo.insert()
        end)
        card
     end
     end
