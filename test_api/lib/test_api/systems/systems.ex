defmodule TestApi.Systems.Systems do
  alias TestApi.Repo
  alias TestApi.Systems.System
  require Logger
  def list_systems do
    Repo.all(System)
  end
  def get_system(id), do: Repo.get(System, id)
  def get_system!(id) do
    case Repo.get(System, id) do
      nil -> {:error, "System not found"}
      system -> {:ok, system}
  end
   end
   def create_system(attrs) do
     %System{}
     |> System.changeset(attrs)
     |> Repo.insert()

   end
   def delete_system(id) do
     system = get_system!(id)
     Repo.delete!(system)
     {:ok, "system was deleted succesfully"}
   end
end
