defmodule TrelloCloneApiWeb.TestController do
  use TrelloCloneApiWeb, :controller

  action_fallback TrelloCloneApiWeb.FallbackController

  def test(conn, _params) do
    text(conn, "Service is running.")
  end

end
