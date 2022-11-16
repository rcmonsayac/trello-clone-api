defmodule TrelloCloneApiWeb.CommentController do
  use TrelloCloneApiWeb, :controller

  alias TrelloCloneApi.Comments
  alias TrelloCloneApi.Comments.Comment

  action_fallback TrelloCloneApiWeb.FallbackController

  plug(Resources, {:comment, :permission})
  plug(Policies, :read_board)


  def index(conn, %{"task_id" => task_id} = _params) do
    comments = Comments.all_task_comments(task_id, [:created_by_user])
    render(conn, "index.json", comments: comments)
  end

  def create(%{assigns: assigns} = conn, params) do
    comment_params = Map.put(params, "created_by_id", assigns.current_user.id)
    with {:ok, %Comment{} = comment} <- Comments.create_comment(comment_params),
         comment <- Comments.get_comment!(comment.id, [:created_by_user]) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id} = comment_params) do
    comment = Comments.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Comments.update_comment(comment, comment_params),
          comment <- Comments.get_comment!(comment.id, [:created_by_user]) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Comments.get_comment!(id)

    with {:ok, %Comment{}} <- Comments.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end


end
