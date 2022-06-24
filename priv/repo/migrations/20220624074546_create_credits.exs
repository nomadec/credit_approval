defmodule App.Repo.Migrations.CreateCredits do
  use Ecto.Migration

  def change do
    create table(:credits, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :approved, :boolean, default: false, null: false
      add :total_income, :integer
      add :total_expenses, :integer
      add :credit_limit, :integer

      add :risk_assessment_id,
          references(:risk_assessments, column: :id, type: :uuid, on_delete: :nothing)

      timestamps()
    end

    create index(:credits, [:risk_assessment_id])
  end
end
