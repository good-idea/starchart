defmodule StarChart.Accounts.UserTest do
  use StarChart.DataCase
  alias StarChart.Accounts.User

  describe "User" do
    @valid_attrs %{
      email: "test@example.com",
      username: "testuser"
    }
    @invalid_email %{
      email: "invalid-email",
      username: "testuser"
    }
    @invalid_username %{
      email: "test@example.com",
      username: "a"  # too short
    }
    @invalid_username_format %{
      email: "test@example.com",
      username: "test user"  # contains space
    }

    test "changeset/2 with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset/2 with invalid email" do
      changeset = User.changeset(%User{}, @invalid_email)
      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "changeset/2 with invalid username length" do
      changeset = User.changeset(%User{}, @invalid_username)
      assert %{username: ["should be at least 3 character(s)"]} = errors_on(changeset)
    end

    test "changeset/2 with invalid username format" do
      changeset = User.changeset(%User{}, @invalid_username_format)
      assert %{username: ["only letters, numbers, underscores, and hyphens allowed"]} = errors_on(changeset)
    end

    test "changeset/2 enforces unique email" do
      {:ok, _user} = Repo.insert(User.changeset(%User{}, @valid_attrs))
      {:error, changeset} = Repo.insert(User.changeset(%User{}, @valid_attrs))
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "changeset/2 enforces unique username" do
      {:ok, _user} = Repo.insert(User.changeset(%User{}, @valid_attrs))
      {:error, changeset} = Repo.insert(User.changeset(%User{}, %{email: "another@example.com", username: "testuser"}))
      assert %{username: ["has already been taken"]} = errors_on(changeset)
    end

    test "login_changeset/1 updates last_login_at" do
      {:ok, user} = Repo.insert(User.changeset(%User{}, @valid_attrs))
      assert user.last_login_at == nil
      
      {:ok, updated_user} = Repo.update(User.login_changeset(user))
      assert updated_user.last_login_at != nil
    end

    test "confirm_changeset/1 updates confirmed_at" do
      {:ok, user} = Repo.insert(User.changeset(%User{}, @valid_attrs))
      assert user.confirmed_at == nil
      
      {:ok, updated_user} = Repo.update(User.confirm_changeset(user))
      assert updated_user.confirmed_at != nil
    end
  end
end
