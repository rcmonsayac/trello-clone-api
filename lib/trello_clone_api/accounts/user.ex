defmodule TrelloCloneApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrelloCloneApi.Boards.BoardPermission
  alias TrelloCloneApi.Boards.Board
  alias TrelloCloneApi.Lists.List
  alias TrelloCloneApi.Tasks.Task
  alias TrelloCloneApi.Comments.Comment

  @derive {Jason.Encoder,
  only: [
    :id,
    :email
  ]}

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    has_many :board_permissions, BoardPermission
    has_many :created_boards, Board, foreign_key: :created_by_id
    has_many :created_lists, List, foreign_key: :created_by_id
    has_many :created_tasks, Task, foreign_key: :created_by_id
    has_many :assigned_tasks, Task, foreign_key: :assignee_id
    has_many :created_comments, Comment, foreign_key: :created_by_id
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_hashed_password
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}}
        ->
          put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
          changeset
    end
  end
end
