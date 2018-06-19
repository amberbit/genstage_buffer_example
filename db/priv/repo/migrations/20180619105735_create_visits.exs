defmodule Db.Repo.Migrations.CreateVisits do
  use Ecto.Migration

  def change do
    create table(:visits) do
      add :remote_ip, :string
      add :host, :string
      add :request_path, :string
    end
  end
end
