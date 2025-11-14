defmodule TestApi.Dashboards.Dashboard do
   @moduledoc """
   Dashboard for users to view
   """
   use Ecto.Schema
   import Ecto.Changeset
   alias TestApi.Systems.System
   alias TestApi.Users.User
   @derive {Jason.Encoder, only: [:id, :name, :system_id, :user_id, :inserted_at, :updated_at]}



   schema "dashboards" do
     field :name, :string
     belongs_to :system, System
     belongs_to :user, User
     timestamps(type: :utc_datetime)
   end

   def changeset(dashboard, attrs) do
     dashboard
     |> cast(attrs, [:name, :system_id, :user_id])
     |> validate_required([:name, :system_id, :user_id])
     |> validate_length(:name, min: 3, max: 255)
     |> foreign_key_constraint(:system_id)
     |> foreign_key_constraint(:user_id)


   end
end
