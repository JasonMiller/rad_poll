defmodule RadPoll.Votes.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    belongs_to :option, RadPoll.Options.Option
    belongs_to :user, RadPoll.Users.User

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:option_id, :user_id])
    |> validate_required([:option_id, :user_id])
  end
end
