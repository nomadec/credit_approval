defmodule App.Repo.Migrations.CreateRiskAssessments do
  use Ecto.Migration

  def change do
    create table(:risk_assessments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :has_paying_job, :boolean, default: false, null: false
      add :employed_for_year, :boolean, default: false, null: false
      add :owns_home, :boolean, default: false, null: false
      add :owns_car, :boolean, default: false, null: false
      add :additional_income, :boolean, default: false, null: false
      add :passed, :boolean, default: false, null: false

      timestamps()
    end
  end
end
