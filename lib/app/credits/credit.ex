defmodule App.Credits.Credit do
  use App.Schema

  import Ecto.Changeset

  schema "credits" do
    field :approved, :boolean, default: false
    field :total_expenses, :integer
    field :total_income, :integer
    field :credit_limit, :integer, default: 0
    field :credit_score, :integer, virtual: true
    belongs_to :risk_assessment, App.Credits.RiskAssessment

    timestamps()
  end

  @doc false
  def changeset(credit, attrs) do
    credit
    |> cast(attrs, [:approved, :total_income, :total_expenses, :credit_limit, :risk_assessment_id])
    |> validate_required([:approved, :total_income, :total_expenses, :credit_limit, :risk_assessment_id])
  end
end
