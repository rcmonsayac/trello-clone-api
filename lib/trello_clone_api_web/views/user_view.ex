defmodule TrelloCloneApiWeb.UserView do
  use TrelloCloneApiWeb, :view
  alias TrelloCloneApiWeb.UserView

  def render("user.json", %{user: user, token: token}) do
    %{
      user: user,
      token: token
    }
  end

  def render("users.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email
    }
  end
end
