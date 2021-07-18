defmodule RadPoll.Repo.Migrations.AddUserIdToVotes do
  use Ecto.Migration

  def change do
    alter table(:votes) do
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:votes, [:user_id])
  end
end
