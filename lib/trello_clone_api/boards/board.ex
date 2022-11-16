defmodule TrelloCloneApi.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrelloCloneApi.Boards.BoardPermission
  alias TrelloCloneApi.Lists.List
  alias TrelloCloneApi.Tasks.Task
  alias TrelloCloneApi.Accounts.User

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "boards" do
    field :description, :string
    field :title, :string
    belongs_to :created_by_user, User, foreign_key: :created_by_id, type: Ecto.UUID
    has_many :board_permissions, BoardPermission
    has_many :lists, List
    has_many :tasks, Task
    timestamps()
  end

  @fields ~w(id title description created_by_id)a
  @doc false
  def changeset(board, attrs) do
    fields = ~w(title description created_by_id)a
    board
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
