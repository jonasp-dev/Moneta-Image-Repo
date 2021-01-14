defmodule Moneta.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :filename, :string
      add :size, :bigint
      add :content_type, :string
      add :hash, :string, size: 64
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end
 
    create index(:images, [:user_id])
  end
end
