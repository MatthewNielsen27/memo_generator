defmodule MemoGenerator.Clients.JiraTest do
    use ExUnit.Case
    import Tesla.Mock

    @clean_issue %{
        "comments" => [],
        "components" => ["Component_A"],
        "created_at" => "2018-10-16 @12:23",
        "creator_email" => "matthew@example.ca",
        "creator_name" => "Matthew Nielsen",
        "desc" => "Fix issues with deployment pipeline",
        "id" => "A-123",
        "last_update" => "2018-10-16 @15:15",
        "priority" => "P1",
        "project" => "A",
        "reporter_email" => "matthew@example.ca",
        "reporter_name" => "Matthew Nielsen",
        "status" => "Done",
        "summary" => "Fix pipeline"
    }

    @issue %{
        "fields" => %{
          "comment" => %{
            "comments" => [],
            "maxResults" => 0,
            "startAt" => 0,
            "total" => 0
          },
          "created" => "2018-10-16T12:23:35.000-0400",
          "labels" => [],
          "updated" => "2018-10-16T15:15:07.000-0400",
          "components" => [
            %{
              "name" => "Component_A",
            }
          ],
          "reporter" => %{
            "displayName" => "Matthew Nielsen",
            "emailAddress" => "matthew@example.ca"
          },
          "status" => %{
            "name" => "Done",
          },
          "creator" => %{
            "displayName" => "Matthew Nielsen",
            "emailAddress" => "matthew@example.ca"
          },
          "priority" => %{
            "name" => "P1",
          },
          "project" => %{
            "key" => "A",
            "name" => "A",
          },
          "description" => "Fix issues with deployment pipeline",
          "assignee" => nil,
          "summary" => "Fix pipeline",
        },
        "id" => "1234",
        "key" => "A-123"
    }

    @board_body %{
        "name" => "BOARD A",
        "type" => "Kanban"
    }


    setup do
        mock fn
            %{method: :get, url: "https://jira.example.com/rest/api/2/board/1/issue"} ->
                %Tesla.Env{status: 200, body: board_issue_body()}
            %{method: :get, url: "https://jira.example.com/rest/api/2/board/1"} ->
                %Tesla.Env{status: 200, body: Poison.encode!(@board_body)}
        end

        MemoGenerator.Application.start(:normal, [:jira_client])
        MemoGenerator.Clients.Config.update(Jira, %{"headers" => [], "base_url" => "https://jira.example.com/rest/api/2"})

        :ok
    end

    def board_issue_body do
        %{
            "issues" => [
                @issue
            ]
        }
        |> Poison.encode!
    end

    test "take_params/1" do
        assert MemoGenerator.Clients.Jira.take_params(@issue) == @clean_issue
    end

    test "sort_by/2" do
        assert MemoGenerator.Clients.Jira.sort_by([@clean_issue], "priority") == %{"P1" => [@clean_issue]}
        assert MemoGenerator.Clients.Jira.sort_by([@clean_issue], "project") == %{"A" => [@clean_issue]}
    end

    test "get_board/1" do
        assert MemoGenerator.Clients.Jira.get_board("1") == @board_body
    end

    test "get_board_issues/1" do
        assert MemoGenerator.Clients.Jira.get_board_issues("1") == [@clean_issue]
    end

    test "get_board_data/2" do
        assert MemoGenerator.Clients.Jira.get_board_data("1", "priority") == %{"name" => "BOARD A", "type" => "Kanban", "issues" => %{"P1" => [@clean_issue]}}
    end

    test "client/0" do
        assert MemoGenerator.Clients.Jira.client() == %Tesla.Client{
            fun: nil,
            post: [],
            pre: [
              {Tesla.Middleware.Headers, :call, [[]]},
              {Tesla.Middleware.BaseUrl, :call,
               ["https://jira.example.com/rest/api/2"]}
            ]
          }
    end
end
