defmodule RadPoll.OptionsTest do
  use RadPoll.DataCase

  alias RadPoll.Options

  describe "options" do
    alias RadPoll.Options.Option

    @valid_attrs %{value: "some value"}
    @update_attrs %{value: "some updated value"}
    @invalid_attrs %{value: nil}

    def option_fixture(attrs \\ %{}) do
      {:ok, option} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Options.create_option()

      option
    end

    test "list_options/0 returns all options" do
      option = option_fixture()
      assert Options.list_options() == [option]
    end

    test "get_option!/1 returns the option with given id" do
      option = option_fixture()
      assert Options.get_option!(option.id) == option
    end

    test "create_option/1 with valid data creates a option" do
      assert {:ok, %Option{} = option} = Options.create_option(@valid_attrs)
      assert option.value == "some value"
    end

    test "create_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Options.create_option(@invalid_attrs)
    end

    test "update_option/2 with valid data updates the option" do
      option = option_fixture()
      assert {:ok, %Option{} = option} = Options.update_option(option, @update_attrs)
      assert option.value == "some updated value"
    end

    test "update_option/2 with invalid data returns error changeset" do
      option = option_fixture()
      assert {:error, %Ecto.Changeset{}} = Options.update_option(option, @invalid_attrs)
      assert option == Options.get_option!(option.id)
    end

    test "delete_option/1 deletes the option" do
      option = option_fixture()
      assert {:ok, %Option{}} = Options.delete_option(option)
      assert_raise Ecto.NoResultsError, fn -> Options.get_option!(option.id) end
    end

    test "change_option/1 returns a option changeset" do
      option = option_fixture()
      assert %Ecto.Changeset{} = Options.change_option(option)
    end
  end
end
