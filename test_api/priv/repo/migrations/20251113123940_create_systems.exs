defmodule TestApi.Repo.Migrations.CreateSystems do
  use Ecto.Migration

  def change do
    create table(:systems) do
      add :name, :string, null: false
      timestamps(type: :utc_datetime)
    end
  end
end
