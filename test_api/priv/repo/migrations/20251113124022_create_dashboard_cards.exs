defmodule TestApi.Repo.Migrations.CreateDashboardCards do
  use Ecto.Migration

  def change do
    create table(:dashboard_cards) do
      add :dashboard_id, references(:dashboards, on_delete: :delete_all), null: false
      add :system_id, references(:systems, on_delete: :delete_all), null: false
      add :x, :integer, null: false
      add :y, :integer, null: false
      add :w, :integer, null: false
      add :h, :integer, null: false
      timestamps(type: :utc_datetime)
    end
    create index(:dashboard_cards, [:dashboard_id])
  end
end
