defmodule RadPoll.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :session_id, :uuid, null: false

      timestamps()
    end
  end
end
