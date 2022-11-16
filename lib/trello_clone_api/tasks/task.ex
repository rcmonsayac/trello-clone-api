defmodule TrelloCloneApi.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias TrelloCloneApi.Boards.Board
  alias TrelloCloneApi.Lists.List
  alias TrelloCloneApi.Accounts.User
  alias TrelloCloneApi.Comments.Comment

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "tasks" do
    field :description, :string
    field :position, :decimal
    field :title, :string
    field :status, TrelloCloneApi.TaskStatus
    belongs_to :created_by_user, User, foreign_key: :created_by_id, type: Ecto.UUID
    belongs_to :assignee_user, User, foreign_key: :assignee_id, type: Ecto.UUID
    belongs_to :list, List, type: Ecto.UUID
    belongs_to :board, Board, type: Ecto.UUID
    has_many :comments, Comment
    timestamps()
  end

  @fields ~w(id title description position status board_id list_id assignee_id created_by_id)a
  @doc false
  def changeset(task, attrs) do
    fields = ~w(
      title
      description
      position
      status
      list_id
      board_id
      assignee_id
      created_by_id
      )a

    required = ~w(
      title
      position
      status
      list_id
      board_id
      created_by_id
      )a

    task
    |> cast(attrs, fields)
    |> validate_required(required)
  end



end
