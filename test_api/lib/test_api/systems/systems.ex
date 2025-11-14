defmodule TestApi.Systems.System do
  @moduledoc """
  System aka companies
  """
  use Ecto.Schema
  import Ecto.Changeset

 @derive {Jason.Encoder, only: [:id, :name, :inserted_at, :updated_at]}

  schema "systems" do
    field :name, :string


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(system, attrs) do
    system
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 3, max: 255)
  end
end
