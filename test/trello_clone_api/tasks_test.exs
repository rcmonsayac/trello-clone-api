defmodule TrelloCloneApi.TasksTest do
  use TrelloCloneApi.DataCase

  alias TrelloCloneApi.Tasks
  alias TrelloCloneApi.Accounts
  alias TrelloCloneApi.Boards
  alias TrelloCloneApi.Lists

  describe "users" do
    alias TrelloCloneApi.Tasks.Task

    @valid_attrs %{description: "some description", title: "some title"}
    @update_attrs %{description: "some updated description", title: "some updated title"}
    @invalid_attrs %{title: nil, descption: nil}


    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
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
      valid_attrs =  %{title: "some title"}
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
      {user, board, list}
    end

    test "all_task/0 returns all tasks" do
      {user, board, list} = setup()
      last_position = Tasks.get_last_position(list.id)
      attrs = %{
        board_id: board.id,
        list_id: list.id,
        created_by_id: user.id,
        position: last_position,
        status: :not_started
      }
      task = task_fixture(attrs)
      assert Tasks.all_task() == [task]
    end

    test "get_task!/1 returns task given a id" do
      {user, board, list} = setup()
      last_position = Tasks.get_last_position(list.id)
      attrs = %{
        board_id: board.id,
        list_id: list.id,
        created_by_id: user.id,
        position: last_position,
        status: :not_started
      }
      task = task_fixture(attrs)
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task!/1 with valid data creates task" do
      {user, board, list} = setup()
      last_position = Tasks.get_last_position(board.id)
      attrs = Map.merge(%{
        board_id: board.id,
        list_id: list.id,
        created_by_id: user.id,
        position: last_position,
        status: :not_started,
        assignee_id: user.id
      }, @valid_attrs)
      assert {:ok, %Task{} = task} = Tasks.create_task(attrs)
      assert task.title == "some title"
      assert task.description == "some description"
      assert task.created_by_id == user.id
      assert task.assignee_id == user.id
      assert task.board_id == board.id
      assert task.list_id == list.id
      assert task.position == last_position
      assert task.status == :not_started
    end

    test "create_task/1 with blank data returns errors" do
      attrs = Map.merge(%{
        board_id: nil,
        created_by_id: nil,
        position: nil,
        list_id: nil,
        status: nil
      }, @invalid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = Tasks.create_task(attrs)

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

      assert {:status, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :status end)
      assert String.contains?(message, "can't be blank")

      assert {:list_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :list_id end)
      assert String.contains?(message, "can't be blank")

    end

    test "create_task/1 with invalid data returns errors" do
      attrs = Map.merge(%{
        board_id: 1234,
        created_by_id: 1234,
        list_id: 1234,
        status: :invalid,
        position: 1,
        assignee_id: 1234,
      }, @valid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = Tasks.create_task(attrs)

      assert {:created_by_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :created_by_id end)
      assert String.contains?(message, "is invalid")

      assert {:board_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :board_id end)
      assert String.contains?(message, "is invalid")

      assert {:list_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :list_id end)
      assert String.contains?(message, "is invalid")

      assert {:status, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :status end)
      assert String.contains?(message, "is invalid")

      assert {:assignee_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :assignee_id end)
      assert String.contains?(message, "is invalid")

    end

    test "update_task!/1 with valid data updates task" do
      {user, board, list} = setup()
      last_position = Tasks.get_last_position(board.id)
      attrs = Map.merge(%{
        board_id: board.id,
        list_id: list.id,
        created_by_id: user.id,
        position: last_position,
        status: :not_started
      }, @valid_attrs)
      assert {:ok, %Task{} = task} = Tasks.create_task(attrs)

      update_attrs = Map.merge(%{
        position: 2,
        status: :in_progress,
        assignee_id: user.id
      }, @update_attrs)

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)

      assert task.title == "some updated title"
      assert task.description == "some updated description"
      assert task.position == Decimal.new(2)
      assert task.status == :in_progress
      assert task.assignee_id == user.id
    end

    test "update_task/1 with invalid data returns error" do
      {user, board, list} = setup()
      last_position = Tasks.get_last_position(board.id)
      attrs = Map.merge(%{
        board_id: board.id,
        list_id: list.id,
        created_by_id: user.id,
        position: last_position,
        status: :not_started
      }, @valid_attrs)
      assert {:ok, %Task{} = task} = Tasks.create_task(attrs)

      update_attrs = Map.merge(%{
        position: "invalid",
        status: :invalid,
        list_id: 1234,
        assignee_id: 1234
        }, @invalid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = Tasks.update_task(task, update_attrs)

      assert {:title, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :title end)
      assert String.contains?(message, "can't be blank")

      assert {:position, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :position end)
      assert String.contains?(message, "is invalid")

      assert {:list_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :list_id end)
      assert String.contains?(message, "is invalid")

      assert {:status, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :status end)
      assert String.contains?(message, "is invalid")

      assert {:assignee_id, {message, _}} =
        Enum.find(changeset.errors, fn {key, _value} -> key == :assignee_id end)
      assert String.contains?(message, "is invalid")

    end


    test "delete_task/1 deletes the task" do
      {user, board, list} = setup()
      last_position = Tasks.get_last_position(list.id)
      attrs = %{
        board_id: board.id,
        list_id: list.id,
        created_by_id: user.id,
        position: last_position,
        status: :not_started
      }
      task = task_fixture(attrs)
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      {user, board, list} = setup()
      last_position = Tasks.get_last_position(list.id)
      attrs = %{
        board_id: board.id,
        list_id: list.id,
        created_by_id: user.id,
        position: last_position,
        status: :not_started
      }
      task = task_fixture(attrs)
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end

  end
end
