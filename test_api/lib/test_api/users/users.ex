defmodule TestApi.Users.User do
  @moduledoc """
   Users aka employees

  """
  use Ecto.Schema
  import Ecto.Changeset
  alias TestApi.Systems.System
  @derive {Jason.Encoder, only: [:id, :name, :system_id, :inserted_at, :updated_at ]}

  schema "users" do
    field :name, :string
    belongs_to :system, System
    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :system_id])
    |> validate_required([:name, :system_id])
    |> validate_length(:name, min: 3, max: 255)
    |> foreign_key_constraint(:system_id)
  end
end
