defmodule TrelloCloneApiWeb.BoardView do
  use TrelloCloneApiWeb, :view
  alias TrelloCloneApiWeb.BoardView
  def render("index.json", %{boards: boards}) do
    render_many(boards, BoardView, "board.json")
  end

  def render("show.json", %{board: board}) do
    render_one(board, BoardView, "board.json")
  end

  def render("board.json", %{board: board}) when is_list(board.lists) and is_list(board.tasks) do
    %{id: board.id,
      title: board.title,
      description: board.description,
      created_by_id: board.created_by_id,
      lists: board.lists,
      tasks: board.tasks
    }
  end

  def render("board.json", %{board: board}) do
    %{id: board.id,
      title: board.title,
      description: board.description,
      created_by_id: board.created_by_id,
      lists: [],
      tasks: []
    }
  end
end
