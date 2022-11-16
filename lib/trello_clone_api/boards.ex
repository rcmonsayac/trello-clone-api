defmodule TrelloCloneApi.Boards do
  import Ecto.Query, warn: false
  alias TrelloCloneApi.Repo

  alias TrelloCloneApi.Boards.Board
  alias TrelloCloneApi.Boards.BoardPermission

  def all_boards do
    Repo.all(Board)
  end

  def all_boards(preload) do
    Repo.all(Board) |> Repo.preload(preload)
  end

  def all_user_boards(user_id) do
    query = from b in Board,
      join: p in BoardPermission, on: b.id == p.board_id and p.user_id == ^user_id,
      select: b

    Repo.all(query)
  end

  def all_board_members(board_id) do
    query = from bp in BoardPermission,
      where: bp.board_id == ^board_id,
      preload: [:user]
    Repo.all(query)
  end

  def get_board!(id), do: Repo.get!(Board, id)

  def get_board!(id, preload), do: Repo.get!(Board, id) |> Repo.preload([preload])

  def create_board(attrs \\ %{}) do
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
  end

  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end


  def get_board_permission!(id), do: Repo.get!(BoardPermission, id)

  def get_board_permission!(id, preload) when is_list(preload), do: Repo.get!(BoardPermission, id) |> Repo.preload(preload)

  def get_board_permission!(board_id, user_id), do: Repo.get_by!(BoardPermission, [board_id: board_id, user_id: user_id])

  def create_board_permission(attrs \\ %{}) do
    %BoardPermission{}
    |> BoardPermission.changeset(attrs)
    |> Repo.insert()
  end

  def update_board_permission(%BoardPermission{} = permission, attrs) do
    permission
    |> BoardPermission.changeset(attrs)
    |> Repo.update()
  end

  def delete_board_permission(%BoardPermission{} = permission) do
    Repo.delete(permission)
  end

  def change_board_permission(%BoardPermission{} = permission, attrs \\ %{}) do
    BoardPermission.changeset(permission, attrs)
  end


end
