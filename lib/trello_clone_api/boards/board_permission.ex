defmodule TrelloCloneApi.Boards.BoardPermission do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrelloCloneApi.Accounts.User
  alias TrelloCloneApi.Boards.Board

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "board_permissions" do
    field :permission_type, TrelloCloneApi.PermissionType
    belongs_to :board, Board, type: Ecto.UUID
    belongs_to :user, User, type: Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(board_permission, attrs) do
    board_permission
    |> cast(attrs, [:permission_type, :user_id, :board_id])
    |> validate_required([:permission_type, :user_id, :board_id])
  end
end
