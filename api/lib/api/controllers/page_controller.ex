defmodule Api.PageController do
  use Api.Web, :controller

  def index(conn, _params) do

    # Db.Repo.insert_all("visits", [%{remote_ip: inspect(conn.remote_ip), host: conn.host, request_path: conn.request_path}])

    Api.Producer.record_visit(%{remote_ip: inspect(conn.remote_ip), host: conn.host, request_path: conn.request_path})

    conn
    |> render("index.json")
  end
end
