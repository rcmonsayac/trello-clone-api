defmodule TrelloCloneApi.CommentsTest do
  use TrelloCloneApi.DataCase


  alias TrelloCloneApi.Accounts
  alias TrelloCloneApi.Boards
  alias TrelloCloneApi.Lists
  alias TrelloCloneApi.Tasks
  alias TrelloCloneApi.Comments

  describe "users" do
    alias TrelloCloneApi.Comments.Comment

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}


    def comment_fixture(attrs \\ %{}) do
      {:ok, comment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Comments.create_comment()
      comment
    end

    def task_fixture(attrs \\ %{}) do
      valid_attrs = %{
        title: "some task title",
        description: "some task description",
        status: :not_started
      }
      {:ok, task} =
        attrs
        |> Enum.into(valid_attrs)
        |> Tasks.create_task()
      task
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

    def list_fixture(attrs \\ %{}) do
      valid_attrs =  %{title: "some list title"}
      {:ok, list} =
        attrs
        |> Enum.into(valid_attrs)
        |> Lists.create_list()
      list
    end

    def setup do
      user = user_fixture()

      board_attrs = %{
        created_by_id: user.id
      }
      board = board_fixture(board_attrs)

      last_position = Lists.get_last_position(board.id)
      list_attrs = %{
        board_id: board.id,
        created_by_id: user.id,
        position: last_position
      }
      list = list_fixture(list_attrs)

      last_position = Tasks.get_last_position(list.id)
      task_attrs = %{
        board_id: board.id,
        created_by_id: user.id,
        position: last_position,
        list_id: list.id
      }
      task = task_fixture(task_attrs)

      {user, board, list, task}
    end

    test "all_comment/0 returns all conmments" do
      {user, _, _, task} = setup()
      attrs = %{
        created_by_id: user.id,
        task_id: task.id
      }
      comment = comment_fixture(attrs)
      assert Comments.all_comment() == [comment]
    end

    test "all_task_comments/2 returns all comments of a task" do
      {user, _, _, task} = setup()
      attrs = %{
        created_by_id: user.id,
        task_id: task.id
      }
      comment = comment_fixture(attrs)
      assert Comments.all_task_comments(task.id) == [comment]
    end


    test "get_comment!/1 returns a comment given an id" do
      {user, _, _, task} = setup()
      attrs = %{
        created_by_id: user.id,
        task_id: task.id
      }
      comment = comment_fixture(attrs)
      comment_with_preload = Comments.get_comment!(comment.id, [:task, :created_by_user])
      assert comment_with_preload.id == comment.id
      assert comment_with_preload.content == comment.content
      assert comment_with_preload.task == task
      assert comment_with_preload.created_by_user.id == user.id
    end

    test "create_comment/1 with valid data creates comment" do
      {user, _, _, task} = setup()
      attrs = Map.merge(%{
        created_by_id: user.id,
        task_id: task.id
      }, @valid_attrs)

      assert {:ok, %Comment{} = comment} = Comments.create_comment(attrs)
      assert comment.content == "some content"
      assert comment.created_by_id == user.id
      assert comment.task_id == task.id
    end

    test "create_comment/1 with blank data returns errors" do
      attrs = Map.merge(%{
        created_by_id: nil,
        task_id: nil
      }, @invalid_attrs)
      assert {:error, %Ecto.Changeset{} = changeset} = Comments.create_comment(attrs)

      assert {:content, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :content end)
      assert String.contains?(message, "can't be blank")

      assert {:created_by_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :created_by_id end)
      assert String.contains?(message, "can't be blank")

      assert {:task_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :task_id end)
      assert String.contains?(message, "can't be blank")

    end

    test "create_comment/1 with invalid data returns errors" do
      attrs = Map.merge(%{
        created_by_id: 1234,
        task_id: 1234
      }, @valid_attrs)
      assert {:error, %Ecto.Changeset{} = changeset} = Comments.create_comment(attrs)

      assert {:created_by_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :created_by_id end)
      assert String.contains?(message, "is invalid")

      assert {:task_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :task_id end)
      assert String.contains?(message, "is invalid")

    end


    test "update_task!/1 with valid data updates comment" do
      {user, _, _, task} = setup()
      attrs = Map.merge(%{
        created_by_id: user.id,
        task_id: task.id
      }, @valid_attrs)

      assert {:ok, %Comment{} = comment} = Comments.create_comment(attrs)

      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, @update_attrs)
      assert comment.content == "some updated content"
    end

    test "update_task!/1 with invalid data return errors" do
      {user, _, _, task} = setup()
      attrs = Map.merge(%{
        created_by_id: user.id,
        task_id: task.id
      }, @valid_attrs)

      assert {:ok, %Comment{} = comment} = Comments.create_comment(attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = Comments.update_comment(comment, @invalid_attrs)
      assert {:content, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :content end)
      assert String.contains?(message, "can't be blank")
    end


    test "delete_task/1 deletes the task" do
      {user, _, _, task} = setup()
      attrs = Map.merge(%{
        created_by_id: user.id,
        task_id: task.id
      }, @valid_attrs)

      assert {:ok, %Comment{} = comment} = Comments.create_comment(attrs)
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

  end
end
