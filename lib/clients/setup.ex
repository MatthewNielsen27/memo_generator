defmodule MemoGenerator.Clients.Setup do
    @moduledoc """
    Module to host the setup
    """

    @lookup %{jira_client: Jira, trello_client: Trello, test_client: Test}

    def start(args) do
        import Supervisor.Spec

        args
        |> Enum.map(fn(key) -> {key, Application.get_env(:memo_generator, key)} end)
        |> Enum.map(fn({key, config}) -> worker(MemoGenerator.Clients.Config, [config, @lookup[key]]) end)
    end
end