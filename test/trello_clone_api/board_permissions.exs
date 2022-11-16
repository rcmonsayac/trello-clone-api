defmodule TrelloCloneApi.ListsTest do
  use TrelloCloneApi.DataCase

  alias TrelloCloneApi.Accounts
  alias TrelloCloneApi.Boards

  describe "board_permissions" do
    alias TrelloCloneApi.Boards.BoardPermission

    def permission_fixture(attrs \\ %{}) do
      {:ok, permission} =
        attrs
        |> Boards.create_board_permission()
      permission
    end

    def user_fixture(attrs \\ %{}) do
      valid_attrs =  %{email: "some_test@testemail.com", password: "some_password"}
      {:ok, user} =
        attrs
        |> Enum.into(valid_attrs)
        |> Accounts.create_user()
      user
    end

    def board_fixture(attrs \\ %{}) do
      board_attrs = %{description: "some description", title: "some title"}
      {:ok, board} =
        attrs
        |> Enum.into(board_attrs)
        |> Boards.create_board()
      board
    end

    def setup do
      user = user_fixture()
      board_attrs = %{
        created_by_id: user.id
      }
      board = board_fixture(board_attrs)
      {user, board}
    end

    test "get_permission!/1 returns permission given an id" do
      {user, board} = setup()
      attrs = %{
        board_id: board.id,
        user_id: user.id,
        permission_type: :manage
      }
      permission = permission_fixture(attrs)
      assert Boards.get_board_permission!(permission.id) == permission
    end

    test "get_permission!/1 returns permission given a board_id and a user_id" do
      {user, board} = setup()
      attrs = %{
        board_id: board.id,
        user_id: user.id,
        permission_type: :manage
      }
      permission = permission_fixture(attrs)
      assert Boards.get_board_permission!(board.id, user.id) == permission
    end

    test "get_permission!/1 returns permission with user and board given an id" do
      {user, board} = setup()
      attrs = %{
        board_id: board.id,
        user_id: user.id,
        permission_type: :manage
      }
      permission = permission_fixture(attrs)
      permission_with_preload = Boards.get_board_permission!(permission.id, [:user, :board])
      assert permission_with_preload.user.id == user.id
      assert permission_with_preload.board == board
    end


    test "create_board_permission!/1 with valid data creates list" do
      {user, board} = setup()
      attrs = %{
        board_id: board.id,
        user_id: user.id,
        permission_type: :manage
      }
      assert {:ok, %BoardPermission{} = permission} = Boards.create_board_permission(attrs)
      assert permission.user_id == user.id
      assert permission.board_id == board.id
      assert permission.permission_type == :manage
    end

    test "create_board_permission/1 with blank data returns errors" do
      attrs = %{
        board_id: nil,
        user_id: nil,
        permission_type: nil
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Boards.create_board_permission(attrs)

      assert {:board_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :board_id end)
      assert String.contains?(message, "can't be blank")

      assert {:user_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :user_id end)
      assert String.contains?(message, "can't be blank")

      assert {:permission_type, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :permission_type end)
      assert String.contains?(message, "can't be blank")
    end

    test "create_board_permission/1 with invalid data returns errors" do
      attrs = %{
        board_id: 1234,
        user_id: 1234,
        permission_type: :invalid
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Boards.create_board_permission(attrs)

      assert {:board_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :board_id end)
      assert String.contains?(message, "is invalid")

      assert {:user_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :user_id end)
      assert String.contains?(message, "is invalid")

      assert {:permission_type, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :permission_type end)
      assert String.contains?(message, "is invalid")
    end

    test "update_board_permission/2 with valid data updates board_permission" do
      {user, board} = setup()
      attrs = %{
        board_id: board.id,
        user_id: user.id,
        permission_type: :manage
      }
      assert {:ok, %BoardPermission{} = permission} = Boards.create_board_permission(attrs)

      update_attrs = %{permission_type: :write}
      assert {:ok, %BoardPermission{} = permission} = Boards.update_board_permission(permission, update_attrs)
      assert permission.permission_type == :write
    end

    test "update_board_permission/2 with invalid data returns error" do
      {user, board} = setup()
      attrs = %{
        board_id: board.id,
        user_id: user.id,
        permission_type: :manage
      }
      assert {:ok, %BoardPermission{} = permission} = Boards.create_board_permission(attrs)

      update_attrs = %{permission_type: :invalid}

      assert {:error, %Ecto.Changeset{} = changeset} = Boards.update_board_permission(permission, update_attrs)

      assert {:permission_type, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :permission_type end)
      assert String.contains?(message, "is invalid")
    end


    test "delete_permission/1 deletes the permission" do
      {user, board} = setup()
      attrs = %{
        board_id: board.id,
        user_id: user.id,
        permission_type: :manage
      }
      assert {:ok, %BoardPermission{} = permission} = Boards.create_board_permission(attrs)

      assert {:ok, %BoardPermission{}} = Boards.delete_board_permission(permission)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_board_permission!(permission.id) end
    end
  end
end
