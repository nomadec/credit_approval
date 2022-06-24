defmodule App.Credits.RiskAssessment do
  use App.Schema

  import Ecto.Changeset

  schema "risk_assessments" do
    field :additional_income, :boolean, default: false
    field :employed_for_year, :boolean, default: false
    field :has_paying_job, :boolean, default: false
    field :owns_car, :boolean, default: false
    field :owns_home, :boolean, default: false
    field :passed, :boolean, default: false
    has_many :credits, App.Credits.Credit

    timestamps()
  end

  @doc false
  def changeset(risk_assessment, attrs) do
    risk_assessment
    |> cast(attrs, [:has_paying_job, :employed_for_year, :owns_home, :owns_car, :additional_income, :passed])
    |> validate_required([:has_paying_job, :employed_for_year, :owns_home, :owns_car, :additional_income, :passed])
  end
end
