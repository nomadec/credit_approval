defmodule AppWeb.CreditController do
  use AppWeb, :controller

  alias App.Credits
  alias App.Credits.Credit

  def new(conn, %{"assessment_id" => assessment_id} = _params) do
    changeset = Credits.change_credit(%Credit{}, %{risk_assessment_id: assessment_id})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"credit" => credit_params}) do
    case Credits.create_credit(credit_params) do
      {:ok, credit} ->
        if credit.approved do
          conn
          |> put_flash(:info, "Your credit application is approved!")
          |> redirect(to: Routes.credit_path(conn, :show, credit))
        else
          conn
          |> put_flash(:error, "Your application is accepted, however credit limit can not be increased.")
          |> redirect(to: Routes.credit_path(conn, :show, credit))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    credit = Credits.get_credit!(id)
    credit = Credits.fetch_update_user_credit_score(credit)
    render(conn, "show.html", credit: credit)
  end
end
