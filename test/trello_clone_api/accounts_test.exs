defmodule TrelloCloneApi.AccountsTest do
  use TrelloCloneApi.DataCase

  alias TrelloCloneApi.Accounts

  describe "users" do
    alias TrelloCloneApi.Accounts.User

    @valid_attrs %{email: "some_test@testemail.com", password: "some_password"}
    @update_attrs %{email: "some_test_updated@testemail.com", password: "some_updated_password"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()
      user
    end

    test "all_users/0 returns all users" do
      user = user_fixture()
      users = Accounts.all_users()
      found_user = Enum.find(users, fn u -> u.id == user.id end)
      assert found_user.email == "some_test@testemail.com"
      assert Comeonin.Bcrypt.checkpw("some_password", found_user.encrypted_password)
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      found_user = Accounts.get_user!(user.id)
      assert found_user.email == "some_test@testemail.com"
      assert Comeonin.Bcrypt.checkpw("some_password", found_user.encrypted_password)
    end

    test "get_user_by_email/1 returns the user with given email" do
      user = user_fixture()
      {:ok, found_user} = Accounts.get_user_by_email(user.email)
      assert found_user.email == "some_test@testemail.com"
      assert Comeonin.Bcrypt.checkpw("some_password", found_user.encrypted_password)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some_test@testemail.com"
      assert Comeonin.Bcrypt.checkpw("some_password", user.encrypted_password)
    end

    test "create_user/1 with empty email returns can't be blank" do
      invalid_email_attr = %{
        email: "",
        password: "some_password"
      }
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(invalid_email_attr)
      assert {:email, {message, _}} =
                Enum.find(changeset.errors, fn {key, _value} -> key == :email end)
      assert String.contains?(message, "can't be blank")
    end

    test "create_user/1 with duplicate email returns has already been taken" do
      _user = user_fixture()
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(@valid_attrs)
      assert {:email, {message, _}} =
                Enum.find(changeset.errors, fn {key, _value} -> key == :email end)
      assert String.contains?(message, "has already been taken")
    end

    test "create_user/1 with invalid email format returns has invalid format" do
      invalid_email_attr = %{
        email: "invalid_email",
        password: "some_password"
      }
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(invalid_email_attr)
      assert {:email, {message, _}} =
                Enum.find(changeset.errors, fn {key, _value} -> key == :email end)
      assert String.contains?(message, "has invalid format")
    end

    test "create_user/1 with empty password length returns can't be blank" do
      invalid_pw_attr = %{
        email: "some_email@test.com",
        password: ""
      }
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(invalid_pw_attr)
      assert {:password, {message, _}} =
                Enum.find(changeset.errors, fn {key, _value} -> key == :password end)
      assert String.contains?(message, "can't be blank")
    end

    test "create_user/1 with invalid password length returns should be at least n characters" do
      invalid_pw_attr = %{
        email: "some_email@test.com",
        password: "123"
      }
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(invalid_pw_attr)
      assert {:password, {message, _}} =
                Enum.find(changeset.errors, fn {key, _value} -> key == :password end)
      assert String.contains?(message, "should be at least %{count} character(s)")
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some_test_updated@testemail.com"
      assert Comeonin.Bcrypt.checkpw("some_updated_password", user.encrypted_password)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
