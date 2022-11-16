defmodule TrelloCloneApi.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :title, :string
      add :position, :decimal
      add :board_id, references(:boards, on_delete: :delete_all)
      add :created_by_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create index(:lists, [:board_id])
    create index(:lists, [:created_by_id])
  end
end
