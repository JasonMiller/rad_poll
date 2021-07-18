defmodule RadPollWeb.OptionLive.Index do
  use RadPollWeb, :live_view

  alias RadPoll.Options
  alias RadPoll.Options.Option

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :options, list_options())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Option")
    |> assign(:option, Options.get_option!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Option")
    |> assign(:option, %Option{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Options")
    |> assign(:option, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    option = Options.get_option!(id)
    {:ok, _} = Options.delete_option(option)

    {:noreply, assign(socket, :options, list_options())}
  end

  defp list_options do
    Options.list_options()
  end
end
