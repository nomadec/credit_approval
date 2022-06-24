defmodule App.CreditsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Credits` context.
  """
  import Ecto.Query, warn: false

  @doc """
  Generate a credit.
  """
  def credit_fixture(attrs \\ %{}) do
    {:ok, credit} =
      attrs
      |> Enum.into(%{
        approved: true,
        total_expenses: 42,
        total_income: 42
      })
      |> App.Credits.create_credit()

    credit
  end

  @doc """
  Generate a risk_assessment.
  """
  def risk_assessment_fixture(attrs \\ %{}) do
    {:ok, risk_assessment} =
      attrs
      |> Enum.into(%{
        additional_income: true,
        employed_for_year: true,
        has_paying_job: true,
        owns_car: true,
        owns_home: true,
        passed: true
      })
      |> App.Credits.create_risk_assessment()

    risk_assessment
  end
end
