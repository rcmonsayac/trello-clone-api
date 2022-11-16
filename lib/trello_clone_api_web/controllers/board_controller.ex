defmodule TrelloCloneApiWeb.BoardController do
  use TrelloCloneApiWeb, :controller

  alias TrelloCloneApi.Boards
  alias TrelloCloneApi.Boards.Board
  alias TrelloCloneApi.Boards.BoardPermission

  plug(Resources, {:board, :permission} when action in [:show, :update, :delete])
  plug(Policies, :read_board when action in [:show])
  plug(Policies, :update_board when action in [:update, :delete])


  action_fallback TrelloCloneApiWeb.FallbackController

  def index(conn, _params) do
    boards = Boards.all_user_boards(conn.assigns.current_user.id)
    render(conn, "index.json", boards: boards)
  end

  def create(%{assigns: assigns} = conn, params) do
    board_params = Map.put(params, "created_by_id", assigns.current_user.id)
    permission_params = %{
      "user_id" => assigns.current_user.id,
      "permission_type" => :manage
    }
    with {:ok, %Board{} = board} <- Boards.create_board(board_params),
         permission_params = Map.merge(%{"board_id" => board.id}, permission_params),
         {:ok, %BoardPermission{} = _permission} <- Boards.create_board_permission(permission_params) do
      conn
      |> put_status(:created)
      |> render("show.json", board: board)
    end
  end

  def show(conn, %{"id" => id}) do
    board = Boards.get_board!(id)
    render(conn, "show.json", board: board)
  end


  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Boards.get_board!(id)

    with {:ok, %Board{} = board} <- Boards.update_board(board, board_params) do
      render(conn, "show.json", board: board)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Boards.get_board!(id)

    with {:ok, %Board{}} <- Boards.delete_board(board) do
      send_resp(conn, :no_content, "")
    end
  end

end
