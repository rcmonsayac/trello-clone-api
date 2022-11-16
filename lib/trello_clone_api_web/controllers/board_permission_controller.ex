defmodule TrelloCloneApiWeb.BoardPermissionController do
  use TrelloCloneApiWeb, :controller

  alias TrelloCloneApi.Boards
  alias TrelloCloneApi.Boards.BoardPermission

  action_fallback TrelloCloneApiWeb.FallbackController

  plug(Resources, {:board_permission, :permission})
  plug(Policies, :read_board when action in [:index, :show])
  plug(Policies, :manage_board when action in [:update, :delete, :create])

  def index(conn, %{"board_id" => board_id}) do
    board_permissions = Boards.all_board_members(board_id)
    render(conn, "index.json", board_permissions: board_permissions)
  end

  def create(conn, params) do
    with {:ok, %BoardPermission{} = permission} <- Boards.create_board_permission(params),
         permission = Boards.get_board_permission!(permission.id, [:user]) do
      conn
      |> put_status(:created)
      |> render("show.json", board_permission: permission)
    end
  end

  def show(conn, %{"board_id" => board_id, "user_id" => user_id}) do
    permission = Boards.get_board_permission!(board_id, user_id)
    render(conn, "show.json", board_permission: permission)
  end

  def update(conn, %{"id" => id} = permission_params) do
    permission = Boards.get_board_permission!(id)

    with {:ok, %BoardPermission{} = permission} <- Boards.update_board_permission(permission, permission_params),
         permission = Boards.get_board_permission!(permission.id, [:user]) do
      render(conn, "show.json", board_permission: permission)
    end
  end

  def delete(conn, %{"id" => id}) do
    permission = Boards.get_board_permission!(id)

    with {:ok, %BoardPermission{}} <- Boards.delete_board_permission(permission) do
      send_resp(conn, :no_content, "")
    end
  end

end
