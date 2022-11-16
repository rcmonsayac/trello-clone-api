defmodule TrelloCloneApi.ListsTest do
  use TrelloCloneApi.DataCase

  alias TrelloCloneApi.Lists
  alias TrelloCloneApi.Accounts
  alias TrelloCloneApi.Boards

  describe "lists" do
    alias TrelloCloneApi.Lists.List

    @valid_attrs %{title: "some title"}

    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil, created_by_id: nil}


    def list_fixture(attrs \\ %{}) do
      {:ok, list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lists.create_list()

      list
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

    test "all_list/0 returns all lists" do
      {user, board} = setup()
      last_position = Lists.get_last_position(board.id)
      attrs = %{
        board_id: board.id,
        created_by_id: user.id,
        position: last_position
      }
      list = list_fixture(attrs)
      assert Lists.all_list() == [list]
    end

    test "get_list!/1 returns the list with given id" do
      {user, board} = setup()
      last_position = Lists.get_last_position(board.id)
      attrs = %{
        board_id: board.id,
        created_by_id: user.id,
        position: last_position
      }
      list = list_fixture(attrs)
      assert Lists.get_list!(list.id) == list
    end

    test "create_list!/1 with valid data creates list" do
      {user, board} = setup()
      last_position = Lists.get_last_position(board.id)
      attrs = Map.merge(%{
        board_id: board.id,
        created_by_id: user.id,
        position: last_position
      }, @valid_attrs)
      assert {:ok, %List{} = list} = Lists.create_list(attrs)
      assert list.title == "some title"
      assert list.created_by_id == user.id
      assert list.board_id == board.id
      assert list.position == last_position
    end

    test "create_list/1 with blank data returns errors" do
      attrs = Map.merge(%{
        board_id: nil,
        created_by_id: nil,
        position: nil
      }, @invalid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = Lists.create_list(attrs)

      assert {:title, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :title end)
      assert String.contains?(message, "can't be blank")

      assert {:created_by_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :created_by_id end)
      assert String.contains?(message, "can't be blank")

      assert {:board_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :board_id end)
      assert String.contains?(message, "can't be blank")

      assert {:position, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :position end)
      assert String.contains?(message, "can't be blank")

    end

    test "create_list/1 with invalid data returns errors" do
      attrs = Map.merge(%{
        board_id: 1234,
        created_by_id: 1234,
        position: 1
      }, @valid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = Lists.create_list(attrs)

      assert {:created_by_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :created_by_id end)
      assert String.contains?(message, "is invalid")

      assert {:board_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :board_id end)
      assert String.contains?(message, "is invalid")

    end

    test "update_list/1 with valid data updates list" do
      {user, board} = setup()
      last_position = Lists.get_last_position(board.id)
      attrs = Map.merge(%{
        board_id: board.id,
        created_by_id: user.id,
        position: last_position
      }, @valid_attrs)
      list= list_fixture(attrs)

      update_attrs = Map.merge(%{position: 2}, @update_attrs)
      assert {:ok, %List{} = list} = Lists.update_list(list, update_attrs)
      assert list.title == "some updated title"
      assert list.position == Decimal.new(2)
    end

    test "update_list/1 with invalid data returns error" do
      {user, board} = setup()
      last_position = Lists.get_last_position(board.id)
      attrs = Map.merge(%{
        board_id: board.id,
        created_by_id: user.id,
        position: last_position
      }, @valid_attrs)
      list= list_fixture(attrs)

      update_attrs = Map.merge(%{position: nil}, @invalid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = Lists.update_list(list, update_attrs)

      assert {:title, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :title end)
      assert String.contains?(message, "can't be blank")

      assert {:position, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :position end)
      assert String.contains?(message, "can't be blank")
    end


    test "delete_list/1 deletes the list" do
      {user, board} = setup()
      last_position = Lists.get_last_position(board.id)
      attrs = %{
        board_id: board.id,
        created_by_id: user.id,
        position: last_position
      }
      list = list_fixture(attrs)
      assert {:ok, %List{}} = Lists.delete_list(list)
      assert_raise Ecto.NoResultsError, fn -> Lists.get_list!(list.id) end
    end

    test "change_list/1 returns a list changeset" do
      {user, board} = setup()
      last_position = Lists.get_last_position(board.id)
      attrs = %{
        board_id: board.id,
        created_by_id: user.id,
        position: last_position
      }
      list = list_fixture(attrs)
      assert %Ecto.Changeset{} = Lists.change_list(list)
    end

  end
end
