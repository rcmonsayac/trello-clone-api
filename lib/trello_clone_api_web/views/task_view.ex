defmodule TrelloCloneApiWeb.TaskView do
  use TrelloCloneApiWeb, :view
  alias TrelloCloneApiWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    render_many(tasks, TaskView, "task.json")
  end

  def render("show.json", %{task: task}) do
    render_one(task, TaskView, "task.json")
  end


  def render("task.json", %{task: task}) when not is_nil(task.assignee_id) do
    %{id: task.id,
      title: task.title,
      description: task.description,
      list_id: task.list_id,
      position: task.position,
      board_id: task.board_id,
      status: task.status,
      created_by_id: task.created_by_id,
      assignee_id: task.assignee_id,
      assignee_user: task.assignee_user
    }
  end

  def render("task.json", %{task: task}) do
    %{id: task.id,
      title: task.title,
      description: task.description,
      list_id: task.list_id,
      position: task.position,
      board_id: task.board_id,
      status: task.status,
      created_by_id: task.created_by_id,
      assignee_id: task.assignee_id
    }
  end

end
