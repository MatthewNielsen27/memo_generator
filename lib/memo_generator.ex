defmodule MemoGenerator do
  @moduledoc """
  Main module for MemoGenerator
  """

  alias MemoGenerator.Markdown

  def render(filename, origin, data, _options \\ []) when origin == :jira do
    {:ok, file} = File.open(filename, [:write, :utf8])

    file
    |> render_basic_title(data["name"])

    for {section, issues} <- data["issues"] do
      file
      |> writeln(Markdown.h2(section))
      |> render_issues(issues)
    end
  end

  defp render_basic_title(file, title) do
    file
    |> writeln(Markdown.h2("Board: #{title}"))
    |> writeln(Markdown.linebreak())
    |> writeln(Markdown.break(2))
  end

  defp render_issues(file, issue_list) do
    for issue <- issue_list do
      file
      |> writeln(Markdown.linebreak())
      |> writeln(Markdown.h4("#{issue["id"]}: #{issue["summary"]}"))
      |> writeln(Markdown.h5("Quick info"))
      |> writeln(Markdown.list("__priority:__ #{issue["priority"]}"))
      |> writeln(Markdown.list("__status:__ #{issue["status"]}"))
      |> writeln(Markdown.list("__team:__ #{issue["project"]}"))
      |> writeln(Markdown.list("__created:__ #{issue["created_at"]}"))
      |> writeln(Markdown.list("__updated:__ #{issue["last_update"]}"))
      |> writeln(
        Markdown.list("__creator:__ #{issue["creator_name"]},  #{issue["creator_email"]}")
      )
      |> writeln(
        Markdown.list("__reporter:__ #{issue["reporter_name"]},  #{issue["reporter_email"]}")
      )
      |> writeln(Markdown.h5("Ticket description"))
      |> writeln(issue["desc"])
    end
  end

  defp writeln(file, text) do
    IO.write(file, text <> "\n\n")

    file
  end
end
