defmodule TrelloCloneApi.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :title, :string
      add :description, :string
      add :created_by_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create index(:boards, [:created_by_id])
  end
end
