defmodule RadPoll.HashId do
  @salt Hashids.new(
          salt: "salt bae",
          min_len: 6
        )

  def encode(id), do: Hashids.encode(@salt, id)

  def decode(id) do
    {:ok, decoded} = Hashids.decode(@salt, id)

    Enum.at(decoded, 0)
  end
end
