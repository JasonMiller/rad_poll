defmodule RadPollWeb.UserLive.Vote do
  use RadPollWeb, :live_view

  alias RadPoll.{Users, Polls, Votes}
  alias RadPoll.Users.User

  @impl true
  def mount(%{"id" => poll_id}, session, socket) do
    user = Users.get_user!(session["user_id"])
    changeset = Users.change_user(user)

    if connected?(socket) do
      poll_id
      |> topic
      |> RadPollWeb.Endpoint.subscribe()
    end

    socket =
      socket
      |> assign(:poll, Polls.get_poll!(poll_id))
      |> assign(:page_title, "Edit User")
      |> assign(:user, user)
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  def handle_event("toggle-vote-for-option", %{"option_id" => option_id} = params, socket) do
    user_id = socket.assigns.user.id

    case Map.get(params, "value") do
      "on" ->
        Votes.create_vote(%{option_id: option_id, user_id: user_id})

      _ ->
        user_id
        |> Votes.get_vote_by_user_id_and_option_id(option_id)
        |> Votes.delete_vote()
    end

    {:ok, poll} = broadcast_poll_updated(socket)

    {:noreply, assign(socket, :poll, poll)}
  end

  def handle_event("change-name", %{"value" => name}, socket) do
    case Users.update_user(socket.assigns.user, %{name: name}) do
      {:ok, user} ->
        {:ok, poll} = broadcast_poll_updated(socket)

        socket =
          socket
          |> assign(:user, user)
          |> assign(:poll, poll)

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def broadcast_poll_updated(socket) do
    poll_id = socket.assigns.poll.id
    poll = Polls.get_poll!(poll_id)

    result =
      poll_id
      |> topic
      |> RadPollWeb.Endpoint.broadcast("poll:updated", poll)

    {result, poll}
  end

  def handle_info(a, b, c), do: raise(a)

  def handle_info(%{topic: message_topic, event: "poll:updated", payload: poll}, socket) do
    cond do
      topic(poll.id) == message_topic ->
        {:noreply, assign(socket, :poll, poll)}

      true ->
        {:noreply, socket}
    end
  end

  defp topic(id), do: "poll:#{id}"
end
