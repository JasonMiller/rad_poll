defmodule RadPollWeb.OptionLiveTest do
  use RadPollWeb.ConnCase

  import Phoenix.LiveViewTest

  alias RadPoll.Options

  @create_attrs %{value: "some value"}
  @update_attrs %{value: "some updated value"}
  @invalid_attrs %{value: nil}

  defp fixture(:option) do
    {:ok, option} = Options.create_option(@create_attrs)
    option
  end

  defp create_option(_) do
    option = fixture(:option)
    %{option: option}
  end

  describe "Index" do
    setup [:create_option]

    test "lists all options", %{conn: conn, option: option} do
      {:ok, _index_live, html} = live(conn, Routes.option_index_path(conn, :index))

      assert html =~ "Listing Options"
      assert html =~ option.value
    end

    test "saves new option", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.option_index_path(conn, :index))

      assert index_live |> element("a", "New Option") |> render_click() =~
               "New Option"

      assert_patch(index_live, Routes.option_index_path(conn, :new))

      assert index_live
             |> form("#option-form", option: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#option-form", option: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.option_index_path(conn, :index))

      assert html =~ "Option created successfully"
      assert html =~ "some value"
    end

    test "updates option in listing", %{conn: conn, option: option} do
      {:ok, index_live, _html} = live(conn, Routes.option_index_path(conn, :index))

      assert index_live |> element("#option-#{option.id} a", "Edit") |> render_click() =~
               "Edit Option"

      assert_patch(index_live, Routes.option_index_path(conn, :edit, option))

      assert index_live
             |> form("#option-form", option: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#option-form", option: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.option_index_path(conn, :index))

      assert html =~ "Option updated successfully"
      assert html =~ "some updated value"
    end

    test "deletes option in listing", %{conn: conn, option: option} do
      {:ok, index_live, _html} = live(conn, Routes.option_index_path(conn, :index))

      assert index_live |> element("#option-#{option.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#option-#{option.id}")
    end
  end

  describe "Show" do
    setup [:create_option]

    test "displays option", %{conn: conn, option: option} do
      {:ok, _show_live, html} = live(conn, Routes.option_show_path(conn, :show, option))

      assert html =~ "Show Option"
      assert html =~ option.value
    end

    test "updates option within modal", %{conn: conn, option: option} do
      {:ok, show_live, _html} = live(conn, Routes.option_show_path(conn, :show, option))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Option"

      assert_patch(show_live, Routes.option_show_path(conn, :edit, option))

      assert show_live
             |> form("#option-form", option: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#option-form", option: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.option_show_path(conn, :show, option))

      assert html =~ "Option updated successfully"
      assert html =~ "some updated value"
    end
  end
end
