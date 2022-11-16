defmodule TrelloCloneApi.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :position, :decimal
      add :status, :string
      add :list_id, references(:lists, on_delete: :delete_all)
      add :board_id, references(:boards, on_delete: :delete_all)
      add :assignee_id, references(:users, on_delete: :nothing)
      add :created_by_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:tasks, [:list_id])
    create index(:tasks, [:board_id])
    create index(:tasks, [:assignee_id])
    create index(:tasks, [:created_by_id])
  end
end
