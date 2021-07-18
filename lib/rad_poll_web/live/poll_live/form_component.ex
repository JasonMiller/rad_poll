defmodule RadPollWeb.PollLive.FormComponent do
  use RadPollWeb, :live_component

  alias RadPoll.Polls
  alias RadPoll.Options
  alias RadPoll.Options.Option

  @impl true
  def update(%{poll: poll} = assigns, socket) do
    changeset = Polls.change_poll(poll)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
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
    save_poll(socket, socket.assigns.action, poll_params)
  end

  def handle_event("add-option", _, socket) do
    existing_options =
      Map.get(socket.assigns.changeset.changes, :options, socket.assigns.poll.options)

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

  defp save_poll(socket, :edit, poll_params) do
    case Polls.update_poll(socket.assigns.poll, poll_params) do
      {:ok, _poll} ->
        {:noreply,
         socket
         |> put_flash(:info, "Poll updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_poll(socket, :new, poll_params) do
    case Polls.create_poll(poll_params) do
      {:ok, _poll} ->
        {:noreply,
         socket
         |> put_flash(:info, "Poll created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
