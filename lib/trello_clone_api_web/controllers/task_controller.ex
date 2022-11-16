defmodule TrelloCloneApiWeb.TaskController do
  use TrelloCloneApiWeb, :controller

  alias TrelloCloneApi.Tasks
  alias TrelloCloneApi.Tasks.Task

  action_fallback TrelloCloneApiWeb.FallbackController

  plug(Resources, {:list, :permission})
  plug(Policies, :read_board when action in [:index, :show])
  plug(Policies, :update_board when action in [:update, :delete, :create])

  def index(conn, %{"board_id" => board_id} = _params) do
    tasks = Tasks.all_board_tasks(board_id, [:assignee_user])
    render(conn, "index.json", tasks: tasks)
  end

  def create(%{assigns: assigns} = conn, %{"list_id" => list_id} = params) do
    task_params = Map.put(params, "created_by_id", assigns.current_user.id)

    position = Tasks.get_last_position(list_id)
    task_params = Map.put(task_params, "position", position)

    with {:ok, %Task{} = task} <- Tasks.create_task(task_params),
         task <- Tasks.get_task!(task.id, [:assignee_user]) do
      conn
      |> put_status(:created)
      |> render("show.json", task: task)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.json", task: task)
  end

  def update(conn, %{"id" => id} = task_params) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params),
          task <- Tasks.get_task!(task.id, [:assignee_user]) do
      render(conn, "show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{}} <- Tasks.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end


end
