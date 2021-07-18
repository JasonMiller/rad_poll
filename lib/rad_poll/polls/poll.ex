defmodule RadPoll.Polls.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    has_many(:options, RadPoll.Options.Option)

    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:title])
    |> cast_assoc(:options)
    |> validate_required([:title])
  end
end
