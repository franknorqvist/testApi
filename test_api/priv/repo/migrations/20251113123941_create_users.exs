defmodule TestApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
   create table(:users) do
     add :name, :string, null: false
     add :system_id, references(:systems, on_delete: :delete_all), null: false
     timestamps(type: :utc_datetime)
   end
   create index(:users, [:system_id])
  end
end
