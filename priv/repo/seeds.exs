# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TrelloCloneApi.Repo.insert!(%TrelloCloneApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TrelloCloneApi.Repo
alias TrelloCloneApi.Accounts.User

Repo.insert!(User.changeset(%User{}, %{email: "test_user1@test.com", password: "password1"}))
