defmodule TrelloCloneApiWeb.SessionController do
  use TrelloCloneApiWeb, :controller

  alias TrelloCloneApi.Accounts
  alias TrelloCloneApi.Accounts.User
  alias TrelloCloneApiWeb.Auth.Guardian


  action_fallback TrelloCloneApiWeb.FallbackController

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> render(TrelloCloneApiWeb.UserView, "user.json", %{user: user, token: token})
    end
  end

  def logout(conn, _params) do
    with Guardian.Plug.sign_out(conn) do
        send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    with user <- Accounts.get_user!(id),
        {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

end
