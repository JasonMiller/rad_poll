defmodule RadPollWeb.PollLive.New do
  use RadPollWeb, :live_view

  alias RadPoll.Polls
  alias RadPoll.Polls.Poll
  alias RadPoll.Options
  alias RadPoll.Options.Option

  @impl true
  def mount(_params, session, socket) do
    poll = %Poll{options: []}

    socket =
      socket
      |> assign(:poll, poll)
      |> assign(:changeset, Polls.change_poll(poll))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"poll" => poll_params}, socket) do
    changeset =
      socket.assigns.poll
      |> Polls.change_poll(poll_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"poll" => poll_params}, socket) do
    case Polls.create_poll(poll_params) do
      {:ok, poll} ->
        {:noreply,
         socket
         |> put_flash(:info, "Poll created successfully")
         |> push_redirect(to: Routes.user_vote_path(socket, :vote, poll))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("add-option", _, socket) do
    existing_options = Map.get(socket.assigns.changeset.changes, :options, socket.assigns.poll.options)

    options =
      existing_options
      |> Enum.concat([
        # NOTE temp_id
        Options.change_option(%Option{temp_id: get_temp_id()})
      ])

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:options, options)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("remove-option", %{"remove" => remove_id}, socket) do
    options =
      socket.assigns.changeset.changes.options
      |> Enum.reject(fn %{data: option} ->
        option.temp_id == remove_id
      end)

    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_assoc(:options, options)

    {:noreply, assign(socket, changeset: changeset)}
  end

  # JUST TO GENERATE A RANDOM STRING
  defp get_temp_id, do: :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)
end
