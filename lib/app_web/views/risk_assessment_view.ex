defmodule AppWeb.RiskAssessmentView do
  use AppWeb, :view

  def assessment_status_message(false),
    do: "Thank you for your answers. We are currently unable to issue credit to you."

  def assessment_status_message(true),
    do: "Great! We have approved your application. You will be notified when your credit is available."
end
