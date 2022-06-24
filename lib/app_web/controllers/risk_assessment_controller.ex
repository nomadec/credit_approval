defmodule AppWeb.RiskAssessmentController do
  use AppWeb, :controller

  alias App.Credits
  alias App.Credits.RiskAssessment

  def new(conn, _params) do
    changeset = Credits.change_risk_assessment(%RiskAssessment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"risk_assessment" => risk_assessment_params}) do
    case Credits.create_risk_assessment(risk_assessment_params) do
      {:ok, risk_assessment} ->
        if risk_assessment.passed do
          conn
          |> put_flash(:info, "Application submitted successfully.")
          |> redirect(to: Routes.credit_path(conn, :new, assessment_id: risk_assessment.id))
        else
          redirect(conn, to: Routes.risk_assessment_path(conn, :show, risk_assessment))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    risk_assessment = Credits.get_risk_assessment!(id)
    render(conn, "show.html", risk_assessment: risk_assessment)
  end
end
