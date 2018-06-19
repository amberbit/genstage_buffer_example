defmodule Api.PageController do
  use Api.Web, :controller

  def index(conn, _params) do
    conn
    |> render("index.json")
  end
end
