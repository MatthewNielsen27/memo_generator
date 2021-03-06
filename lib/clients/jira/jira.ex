defmodule MemoGenerator.Clients.Jira do
  @moduledoc """
  Client for Jira transactions
  """

  use Tesla

  def get_board_data(id, order, exclude \\ []) do
    board_overview = get_board(id)

    %{
      "name" => board_overview["name"],
      "type" => board_overview["type"],
      "issues" => id |> get_board_issues |> sort_by(order) |> filter_by(exclude)
    }
  end

  def get_board(id) do
    with {:ok, resp} <- get(client(), "/board/#{id}") do
      resp
      |> take_body
      |> Poison.decode!()
    end
  end

  def get_board_issues(id) do
    with {:ok, resp} <- get(client(), "/board/#{id}/issue") do
      resp
      |> take_body
      |> Poison.decode!()
      |> take_issues
      |> parse_fields
    end
  end

  def sort_by(fields, mode) do
    fields
    |> Enum.sort_by(fn p -> p[mode] end)
    |> Enum.chunk_by(fn p -> p[mode] end)
    |> Enum.map(fn [head | tail] -> %{head[mode] => [head | tail]} end)
    |> Enum.reduce(%{}, fn acc, map -> Map.merge(acc, map) end)
  end

  def filter_by(field, mode) do
    Map.drop(field, mode)
  end

  defp parse_fields(issue_list) do
    issue_list
    |> Enum.map(fn issue -> take_params(issue) end)
  end

  defp take_body(params), do: params.body
  defp take_issues(body), do: body["issues"]

  defp process_components(components) do
    components
    |> Enum.map(fn component -> component["name"] end)
  end

  def take_params(issue) do
    inner = issue["fields"]

    %{
      "components" => process_components(inner["components"]),
      "reporter_name" => inner["reporter"]["displayName"],
      "reporter_email" => inner["reporter"]["emailAddress"],
      "creator_name" => inner["creator"]["displayName"],
      "creator_email" => inner["creator"]["emailAddress"],
      "status" => inner["status"]["name"],
      "id" => issue["key"],
      "desc" => clean(inner["description"]),
      "project" => inner["project"]["name"],
      "priority" => inner["priority"]["name"],
      "comments" => parse_comments(inner["comment"]["comments"]),
      "summary" => clean(inner["summary"]),
      "created_at" => parse_date(inner["created"]),
      "last_update" => parse_date(inner["updated"])
    }
  end

  def clean(string) do
    if string !== nil do
      string
      |> String.replace("{code:java}", "```java\n")
      |> String.replace("{code:html}", "```html\n")
      |> String.replace("{code:java}", "```java\n")
      |> String.replace("{code:javasript}", "```javascript\n")
      |> String.replace("{code:elixir}", "```elixir\n")
      |> String.replace("{code:console}", "```console\n")
      |> String.replace("{code:python}", "```python\n")
      |> String.replace("{code}", "```")
      |> String.replace("h4.", "#### ")
      |> String.replace("h3.", "### ")
      |> String.replace("h2.", "## ")
      |> String.replace("h1.", "# ")
    else
      ""
    end
  end

  defp parse_comments(comments) do
    comments
    |> Enum.map(fn comment -> take_comment_fields(comment) end)
  end

  defp take_comment_fields(comment) do
    %{
      "displayName" => comment["author"]["displayName"],
      "emailAddress" => comment["author"]["emailAddress"],
      "avatar" => comment["author"]["avatarUrls"]["48x48"],
      "body" => clean(comment["body"]),
      "created" => comment["created"],
      "updated" => comment["updated"]
    }
  end

  defp parse_date(date) do
    {:ok, dt} = Timex.Parse.DateTime.Parser.parse(date, "{ISO:Extended}")

    "#{dt.year}-#{dt.month}-#{dt.day} @#{dt.hour}:#{dt.minute}"
  end

  def client do
    Tesla.build_client([
      {Tesla.Middleware.Headers, MemoGenerator.Clients.Config.get(Jira, "headers")},
      {Tesla.Middleware.BaseUrl, MemoGenerator.Clients.Config.get(Jira, "base_url")}
    ])
  end
end
