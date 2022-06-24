defmodule App.CreditsTest do
  use App.DataCase

  import App.CreditsFixtures

  alias App.Credits
  alias App.Credits.{Credit, RiskAssessment}

  setup do
    risk_assessment = risk_assessment_fixture()
    credit = credit_fixture(%{risk_assessment_id: risk_assessment.id})

    %{risk_assessment: risk_assessment, credit: credit}
  end

  describe "credits" do
    @invalid_attrs %{approved: nil, total_expenses: nil, total_income: nil}

    test "get_credit!/1 returns the credit with given id", %{credit: credit} do
      assert Credits.get_credit!(credit.id) == credit
    end

    test "create_credit/1 with valid data creates a credit", %{risk_assessment: risk_assessment} do
      good_attrs = %{total_income: 100, total_expenses: 90, risk_assessment_id: risk_assessment.id}
      bad_attrs = %{total_income: 100, total_expenses: 110, risk_assessment_id: risk_assessment.id}

      assert {:ok, %Credit{} = approved_credit} = Credits.create_credit(good_attrs)
      assert approved_credit.approved == true
      assert approved_credit.total_income == 100
      assert approved_credit.total_expenses == 90
      assert approved_credit.credit_limit == 120

      assert {:ok, %Credit{} = failed_credit} = Credits.create_credit(bad_attrs)
      assert failed_credit.approved == false
      assert failed_credit.total_income == 100
      assert failed_credit.total_expenses == 110
      assert failed_credit.credit_limit == 0
    end

    test "create_credit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Credits.create_credit(@invalid_attrs)
    end

    test "change_credit/1 returns a credit changeset", %{credit: credit} do
      assert %Ecto.Changeset{} = Credits.change_credit(credit)
    end
  end

  describe "risk_assessments" do
    @invalid_attrs %{
      additional_income: nil,
      employed_for_year: nil,
      has_paying_job: nil,
      owns_car: nil,
      owns_home: nil,
      passed: nil
    }

    test "get_risk_assessment!/1 returns the risk_assessment with given id", %{risk_assessment: risk_assessment} do
      assert Credits.get_risk_assessment!(risk_assessment.id) == risk_assessment
    end

    test "create_risk_assessment/1 with valid data creates a risk_assessment" do
      good_attrs = %{
        has_paying_job: true,
        employed_for_year: true,
        owns_home: true,
        owns_car: true,
        additional_income: true
      }

      bad_attrs = %{
        has_paying_job: false,
        employed_for_year: false,
        owns_home: true,
        owns_car: true,
        additional_income: true
      }

      assert {:ok, %RiskAssessment{} = passed_risk_assessment} = Credits.create_risk_assessment(good_attrs)
      assert passed_risk_assessment.has_paying_job == true
      assert passed_risk_assessment.employed_for_year == true
      assert passed_risk_assessment.owns_home == true
      assert passed_risk_assessment.owns_car == true
      assert passed_risk_assessment.additional_income == true
      assert passed_risk_assessment.passed == true

      assert {:ok, %RiskAssessment{} = failed_risk_assessment} = Credits.create_risk_assessment(bad_attrs)
      assert failed_risk_assessment.has_paying_job == false
      assert failed_risk_assessment.employed_for_year == false
      assert failed_risk_assessment.owns_home == true
      assert failed_risk_assessment.owns_car == true
      assert failed_risk_assessment.additional_income == true
      assert failed_risk_assessment.passed == false
    end

    test "create_risk_assessment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Credits.create_risk_assessment(@invalid_attrs)
    end

    test "change_risk_assessment/1 returns a risk_assessment changeset", %{risk_assessment: risk_assessment} do
      assert %Ecto.Changeset{} = Credits.change_risk_assessment(risk_assessment)
    end
  end
end
