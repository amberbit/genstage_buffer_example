defmodule Api.PageView do
  use Api.Web, :view

  def render("index.json", _) do
    %{stauts: "OK"}
  end
end
