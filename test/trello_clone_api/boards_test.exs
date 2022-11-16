defmodule TrelloCloneApi.BoardsTest do
  use TrelloCloneApi.DataCase

  alias TrelloCloneApi.Boards
  alias TrelloCloneApi.Accounts

  describe "boards" do
    alias TrelloCloneApi.Boards.Board

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{description: nil, title: nil, created_by_id: nil}

    def board_fixture(attrs \\ %{}) do
      {:ok, board} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Boards.create_board()

      board
    end

    def user_fixture(attrs \\ %{}) do
      valid_attrs =  %{email: "some_test@testemail.com", password: "some_password"}
      {:ok, user} =
        attrs
        |> Enum.into(valid_attrs)
        |> Accounts.create_user()
      user
    end

    test "all_boards/0 returns all boards" do
      user = user_fixture()
      attrs = %{
        created_by_id: user.id
      }
      board = board_fixture(attrs)
      assert Boards.all_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      user = user_fixture()
      attrs = %{
        created_by_id: user.id
      }
      board = board_fixture(attrs)
      assert Boards.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      user = user_fixture()
      attrs = Map.merge(%{created_by_id: user.id}, @valid_attrs)
      assert {:ok, %Board{} = board} = Boards.create_board(attrs)
      assert board.description == "some description"
      assert board.title == "some title"
      assert board.created_by_id == user.id
    end

    test "create_board/1 with blank title and created_by returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Boards.create_board(@invalid_attrs)
      assert {:title, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :title end)
      assert String.contains?(message, "can't be blank")
      assert {:created_by_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :created_by_id end)
      assert String.contains?(message, "can't be blank")
    end

    test "create_board/1 with invalid user returns error changeset" do
      attrs = %{
        title: "some title",
        created_by_id: "12345"
      }
      assert {:error, %Ecto.Changeset{} = changeset} = Boards.create_board(attrs)
      assert {:created_by_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :created_by_id end)
      assert String.contains?(message, "is invalid")
    end


    test "update_board/2 with valid data updates the board" do
      user = user_fixture()
      attrs = %{
        created_by_id: user.id
      }
      board = board_fixture(attrs)
      assert {:ok, %Board{} = board} = Boards.update_board(board, @update_attrs)
      assert board.description == "some updated description"
      assert board.title == "some updated title"
    end

    test "update_board/2 with invalid data returns error changeset" do
      user = user_fixture()
      attrs = %{
        created_by_id: user.id
      }
      board = board_fixture(attrs)
      assert {:error, %Ecto.Changeset{} = changeset} = Boards.update_board(board, @invalid_attrs)
      assert {:title, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :title end)
      assert String.contains?(message, "can't be blank")
      assert {:created_by_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :created_by_id end)
      assert String.contains?(message, "can't be blank")
    end

    test "delete_board/1 deletes the board" do
      user = user_fixture()
      attrs = %{
        created_by_id: user.id
      }
      board = board_fixture(attrs)
      assert {:ok, %Board{}} = Boards.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Boards.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      user = user_fixture()
      attrs = %{
        created_by_id: user.id
      }
      board = board_fixture(attrs)
      assert %Ecto.Changeset{} = Boards.change_board(board)
    end
  end
end
