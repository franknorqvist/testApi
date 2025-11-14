defmodule TestApi.Repo.Migrations.AddUserIdToDashboards do
  use Ecto.Migration

  def change do
  alter table(:dashboards) do
    add :user_id, references(:users, on_delete: :delete_all), null: false
  end
  create index(:dashboards, [:user_id])
  end
end
