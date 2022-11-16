defmodule TrelloCloneApi.Repo do
  use Ecto.Repo,
    otp_app: :trello_clone_api,
    adapter: Ecto.Adapters.Postgres
end
