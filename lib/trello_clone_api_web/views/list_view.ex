defmodule TrelloCloneApiWeb.ListView do
  use TrelloCloneApiWeb, :view
  alias TrelloCloneApiWeb.ListView

  def render("index.json", %{lists: lists}) do
    render_many(lists, ListView, "list.json")
  end

  def render("show.json", %{list: list}) do
    render_one(list, ListView, "list.json")
  end

  def render("list.json", %{list: list}) do
    %{id: list.id,
      title: list.title,
      board_id: list.board_id,
      position: list.position,
      created_by_id: list.created_by_id
  }
  end
end
