defmodule RadPoll.Options.Option do
  use Ecto.Schema
  import Ecto.Changeset

  schema "options" do
    belongs_to(:poll, RadPoll.Polls.Poll)

    field :value, :string

    field :temp_id, :string, virtual: true
    field :delete, :boolean, virtual: true

    timestamps()
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> Map.put(:temp_id, option.temp_id || attrs["temp_id"])
    |> cast(attrs, [:value, :delete])
    |> validate_required([:value])
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
