defmodule RadPollWeb.PollLive.Show do
  use RadPollWeb, :live_view

  alias RadPoll.Polls
  alias RadPoll.Votes

  @impl true
  def mount(%{"id" => id}, session, socket) do
    id
    |> topic
    |> RadPollWeb.Endpoint.subscribe()

    {:ok, assign(socket, :user_id, session.user_id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:poll, Polls.get_poll!(id))}
  end

  def handle_event("vote-for-option", %{"option_id" => option_id}, socket) do
    Votes.create_vote(%{option_id: option_id, user_id: socket.assigns.user_id})
    poll_id = socket.assigns.poll.id
    poll = Polls.get_poll!(poll_id)

    poll_id
    |> topic
    |> RadPollWeb.Endpoint.broadcast("poll:updated", poll)

    {:noreply, assign(socket, :poll, poll)}
  end

  def handle_info(%{topic: message_topic, event: "poll:updated", payload: poll}, socket) do
    cond do
      topic(poll.id) == message_topic ->
        {:noreply, assign(socket, :poll, poll)}

      true ->
        {:noreply, socket}
    end
  end

  defp page_title(:show), do: "Show Poll"
  defp page_title(:edit), do: "Edit Poll"

  defp topic(id), do: "poll:#{id}"
end
