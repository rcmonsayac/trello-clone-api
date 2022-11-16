defmodule TrelloCloneApiWeb.UserController do
  use TrelloCloneApiWeb, :controller

  alias TrelloCloneApi.Accounts
  alias TrelloCloneApi.Accounts.User
  alias TrelloCloneApiWeb.Auth.Guardian


  action_fallback TrelloCloneApiWeb.FallbackController

  def register(conn, params) do
    with {:ok, %User{} = user} <- Accounts.create_user(params),
    {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    else
      error -> error
    end
  end

  def search(conn, _params) do
    %{"email" => email} = conn.query_params
    users = Accounts.search_user_by_email(email)
    render(conn, "users.json", %{users: users})
  end

  def delete(conn, %{"id" => id}) do
    with user <- Accounts.get_user!(id),
        {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end



end
