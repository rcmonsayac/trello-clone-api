defmodule TrelloCloneApi.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrelloCloneApi.Boards.Board
  alias TrelloCloneApi.Tasks.Task
  alias TrelloCloneApi.Accounts.User


  @derive {Jason.Encoder,
  only: [
    :id,
    :title,
    :position,
    :board_id,
    :created_by_id
  ]}

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "lists" do
    field :title, :string
    field :position, :decimal
    belongs_to :board, Board, type: Ecto.UUID
    belongs_to :created_by_user, User, foreign_key: :created_by_id, type: Ecto.UUID
    has_many :tasks, Task
    timestamps()
  end

  @fields ~w(id board_id title position created_by_id)a
  @doc false
  def changeset(list, attrs) do
    fields = ~w(board_id title position created_by_id)a
    list
    |> cast(attrs, fields)
    |> validate_required(fields)
  end

end
