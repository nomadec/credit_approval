defmodule App.Credits do
  @moduledoc """
  The Credits context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Credits.{Credit, RiskAssessment}

  @approval_threshold 6
  @answer_points %{
    has_paying_job: 4,
    employed_for_year: 2,
    owns_home: 2,
    owns_car: 1,
    additional_income: 2
  }
  @credit_multiplier 12
  @credit_score_api_url "https://lxzau4xjot.api.quickmocker.com/creditScore"

  @doc """
  Gets a single credit.

  Raises `Ecto.NoResultsError` if the Credit does not exist.

  ## Examples

      iex> get_credit!(123)
      %Credit{}

      iex> get_credit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_credit!(id), do: Repo.get!(Credit, id)

  @doc """
  Creates a credit.

  ## Examples

      iex> create_credit(%{field: value})
      {:ok, %Credit{}}

      iex> create_credit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_credit(attrs) do
    %Credit{}
    |> Credit.changeset(attrs)
    |> maybe_approve_credit()
    |> Repo.insert()
  end

  defp maybe_approve_credit(%{valid?: false} = changeset), do: changeset

  defp maybe_approve_credit(%{valid?: true, changes: changes} = changeset) do
    excess = changes.total_income - changes.total_expenses
    is_approved = excess > 0
    credit_limit = if is_approved, do: excess * @credit_multiplier, else: 0
    changes = Map.put(changes, :approved, is_approved)
    changes = Map.put(changes, :credit_limit, credit_limit)
    _changeset = Map.put(changeset, :changes, changes)
  end

  def fetch_update_user_credit_score(%Credit{risk_assessment_id: risk_assessment_id} = credit) do
    with %RiskAssessment{} = assessment <- Repo.get(RiskAssessment, risk_assessment_id),
         points <- calc_total_points(assessment) do
      task = Task.async(fn -> fetch_user_credit_score(points) end)
      credit_score = Task.await(task)
      %Credit{credit | credit_score: credit_score}
    end
  end

  defp fetch_user_credit_score(points) do
    url = "#{@credit_score_api_url}/#{points}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"creditScore" => score} = Jason.decode!(body)
        score

      _ ->
        nil
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credit changes.

  ## Examples

      iex> change_credit(credit)
      %Ecto.Changeset{data: %Credit{}}

  """
  def change_credit(%Credit{} = credit, attrs \\ %{}) do
    Credit.changeset(credit, attrs)
  end

  @doc """
  Gets a single risk_assessment.

  Raises `Ecto.NoResultsError` if the Risk assessment does not exist.

  ## Examples

      iex> get_risk_assessment!(123)
      %RiskAssessment{}

      iex> get_risk_assessment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_risk_assessment!(id), do: Repo.get!(RiskAssessment, id)

  @doc """
  Performs risk assessment by calculating total points on provided answers and
  saves a record with `passed: true` if approval_threshold passed, else `false` by default.
  """
  def create_risk_assessment(attrs) do
    %RiskAssessment{}
    |> RiskAssessment.changeset(attrs)
    |> maybe_pass_assessment()
    |> Repo.insert()
  end

  defp maybe_pass_assessment(changeset) do
    total_points = calc_total_points(changeset.changes)
    is_passed = if total_points > @approval_threshold, do: true, else: false
    changes = Map.put(changeset.changes, :passed, is_passed)
    _changeset = Map.put(changeset, :changes, changes)
  end

  defp calc_total_points(%RiskAssessment{} = assessment),
    do: assessment |> Map.from_struct() |> Map.drop([:__meta__]) |> calc_total_points()

  defp calc_total_points(answers) do
    answers
    |> Map.keys()
    |> Enum.reduce(0, fn key, acc ->
      if @answer_points[key] && answers[key], do: acc + @answer_points[key], else: acc
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking risk_assessment changes.

  ## Examples

      iex> change_risk_assessment(risk_assessment)
      %Ecto.Changeset{data: %RiskAssessment{}}

  """
  def change_risk_assessment(%RiskAssessment{} = risk_assessment, attrs \\ %{}) do
    RiskAssessment.changeset(risk_assessment, attrs)
  end
end
