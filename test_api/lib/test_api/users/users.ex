defmodule TestApi.Users.Users do
  alias TestApi.Repo
  alias TestApi.Users.User
  require Logger

   def list_users do
     Repo.all(User)
   end


   def get_user(id) do
     case Repo.get(User, id) do
       nil -> {:error, "User not found"}
       user -> {:ok, user}
     end
   end

   def create_user(attrs) do
     %User{}
     |> User.changeset(attrs)
     |> Repo.insert()
   end

end
