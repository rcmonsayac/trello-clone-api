defmodule TrelloCloneApiWeb.Resources.BoardResources do

  alias TrelloCloneApi.Boards
  alias TrelloCloneApi.Boards.BoardPermission

  alias TrelloCloneApi.Tasks
  alias TrelloCloneApi.Tasks.Task


  def resource(conn, {:board, :permission}, %{"id" => board_id}) do
    user_id = conn.assigns.current_user.id
    resource(:board_permission, board_id, user_id)
  end

  def resource(conn, {resource, :permission}, %{"board_id" => board_id})
      when resource in [:list, :board_permission]  do

    user_id = conn.assigns.current_user.id
    resource(:board_permission, board_id, user_id)
  end

  def resource(conn, {:comment, :permission}, %{"task_id" => task_id}) do
    user_id = conn.assigns.current_user.id
    with %Task{} = task <- Tasks.get_task!(task_id) do
      resource(:board_permission, task.board_id, user_id)
    else
      _ ->
        {:error, :board_permission}
    end
  end

  def resource(:board_permission, board_id, user_id) do
    with %BoardPermission{} = permission <- Boards.get_board_permission!(board_id, user_id) do
      {:ok, :board_permission, permission}
    else
      _ ->
        {:error, :board_permission}
    end
  end


end
