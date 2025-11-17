defmodule TestApi.Dashboards.DashboardCard do
 @moduledoc """
 cards for your personal dashboard
 """
 use Ecto.Schema
 import Ecto.Changeset
 alias TestApi.Systems.System
 alias TestApi.Dashboards.Dashboard
 @derive {Jason.Encoder, only: [:id, :system_id, :dashboard_id, :x, :y, :w, :h, :inserted_at, :updated_at]}



 schema "dashboard_cards" do
   field :x, :integer
   field :y, :integer
   field :w, :integer
   field :h, :integer
   belongs_to :system, System
   belongs_to :dashboard, Dashboard
   timestamps(type: :utc_datetime)

  end
   def changeset(dashboard_card, attrs) do
     dashboard_card
     |> cast(attrs, [:x, :y, :w, :h, :system_id, :dashboard_id])
     |> validate_required([:x, :y, :w, :h, :system_id, :dashboard_id])
     |> foreign_key_constraint(:system_id)
     |> foreign_key_constraint(:dashboard_id)
     |> validate_number(:x, greater_than_or_equal_to: 0)
     |> validate_number(:y, greater_than_or_equal_to: 0)
     |> validate_number(:w, greater_than_or_equal_to: 0)
     |> validate_number(:h, greater_than_or_equal_to: 0)



 end
end
