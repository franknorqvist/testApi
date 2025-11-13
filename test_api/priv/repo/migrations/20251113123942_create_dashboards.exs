defmodule TestApi.Repo.Migrations.CreateDashboards do
  use Ecto.Migration

  def change do
    create table(:dashboards) do
      add :system_id, references(:systems, on_delete: :delete_all), null: false
      add :name, :string, null: false
      timestamps(type: :utc_datetime)
    end
    index(:dashboards, [:system_id])
  end
end
