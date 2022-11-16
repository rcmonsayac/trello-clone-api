defmodule TrelloCloneApi.Tasks do

  import Ecto.Query, warn: false
  alias TrelloCloneApi.Repo

  alias TrelloCloneApi.Tasks.Task


  def all_task do
    Repo.all(Task)
  end

  def all_board_tasks(board_id, preload) do
    query =
      from t in Task,
        where: t.board_id == ^board_id,
        preload: ^preload
    Repo.all(query)
    |> Repo.preload(preload)
  end

  def get_task!(id), do: Repo.get!(Task, id)

  def get_task!(id, preload), do: Repo.get!(Task, id) |> Repo.preload(preload)

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end


  def get_last_position(list_id) do
    query =
      from t in Task,
        where: t.list_id == ^list_id,
        select: max(t.position)

    Repo.one(query)
    |> Kernel.||(0)
    |> Decimal.add(1)
  end

end
