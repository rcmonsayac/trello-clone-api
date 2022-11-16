defmodule TrelloCloneApi.Accounts do
  import Ecto.Query, warn: false
  alias TrelloCloneApi.Repo

  alias TrelloCloneApi.Accounts.User

  def all_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)


  def get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :not_found}
      user ->
        {:ok, user}
    end
  end

  def search_user_by_email(email) do
    email_q = "%#{email}%"
    query =
      from u in User,
      where: ilike(u.email, ^email_q),
      limit: 10
    Repo.all(query)

  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end


  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end


  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
