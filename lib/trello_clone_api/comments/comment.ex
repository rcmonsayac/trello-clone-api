defmodule TrelloCloneApi.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias TrelloCloneApi.Accounts.User
  alias TrelloCloneApi.Tasks.Task

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "comments" do
    field :content, :string
    belongs_to :created_by_user, User, foreign_key: :created_by_id, type: Ecto.UUID
    belongs_to :task, Task, type: Ecto.UUID
    timestamps()
  end

  @fields ~w(id content created_by_id task_id)a

  @doc false
  def changeset(comment, attrs) do
    fields = ~w(content created_by_id task_id)a
    comment
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
