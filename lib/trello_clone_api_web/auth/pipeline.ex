defmodule TrelloCloneApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :trello_clone_api,
    module: TrelloCloneApiWeb.Auth.Guardian,
    error_handler: TrelloCloneApiWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
