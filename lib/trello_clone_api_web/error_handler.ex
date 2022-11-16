defmodule TrelloCloneApiWeb.ErrorHandler do
  import Plug.Conn
  use Phoenix.Controller
  alias TrelloCloneApiWeb.ErrorView

  def policy_error(conn, :unauthenticated) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render(:"401")
    |> halt()
  end

  def policy_error(conn, :forbidden) do
    conn
    |> put_status(:forbidden)
    |> put_view(ErrorView)
    |> render(:"403")
    |> halt()
  end

  def resource_not_found(conn, _resource) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render(:"404")
    |> halt()
  end
end
