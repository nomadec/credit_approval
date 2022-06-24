defmodule AppWeb.FourOhFourController do
  use AppWeb, :controller

  def index(conn, _params) do
    conn
    |> send_resp(:forbidden, "Forbidden\n")
    |> halt
  end
end
