defmodule RadPollWeb.UserPlug do
  alias Plug.Conn
  alias RadPoll.Users

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign_session_id()
    |> assign_user_id()
  end

  defp assign_session_id(conn) do
    if Conn.get_session(conn, :session_id) do
      conn
    else
      session_id = Ecto.UUID.generate()
      Conn.put_session(conn, :session_id, session_id)
    end
  end

  defp assign_user_id(conn) do
    user =
      conn
      |> Conn.get_session(:session_id)
      |> Users.find_or_create_user_by_session_id()

    Conn.put_session(conn, :user_id, user.id)
  end
end
