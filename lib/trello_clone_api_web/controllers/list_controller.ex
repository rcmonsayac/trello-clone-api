defmodule TrelloCloneApiWeb.ListController do
  use TrelloCloneApiWeb, :controller

  alias TrelloCloneApi.Lists
  alias TrelloCloneApi.Lists.List

  action_fallback TrelloCloneApiWeb.FallbackController

  plug(Resources, {:list, :permission})
  plug(Policies, :read_board when action in [:index, :show])
  plug(Policies, :update_board when action in [:update, :delete, :create])

  def index(conn, %{"board_id" => board_id} = _params) do
    lists = Lists.all_board_lists(board_id)
    render(conn, "index.json", lists: lists)
  end

  def create(%{assigns: assigns} = conn, %{"board_id" => board_id} = params) do
    list_params = Map.put(params, "created_by_id", assigns.current_user.id)

    position = Lists.get_last_position(board_id)
    list_params = Map.put(list_params, "position", position)

    with {:ok, %List{} = list} <- Lists.create_list(list_params) do
      conn
      |> put_status(:created)
      |> render("show.json", list: list)
    end
  end

  def show(conn, %{"id" => id}) do
    list = Lists.get_list!(id)
    render(conn, "show.json", list: list)
  end

  def update(conn, %{"id" => id} = list_params) do
    list = Lists.get_list!(id)

    with {:ok, %List{} = list} <- Lists.update_list(list, list_params) do
      render(conn, "show.json", list: list)
    end
  end

  def delete(conn, %{"id" => id} = _list_params) do
    list = Lists.get_list!(id)

    with {:ok, %List{}} <- Lists.delete_list(list) do
      send_resp(conn, :no_content, "")
    end
  end


end
