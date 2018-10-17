defmodule MemoGenerator.Client.SetupTest do
  use ExUnit.Case

  test "start a Jira config" do
    assert MemoGenerator.Clients.Setup.start([:test_client]) == [
             {MemoGenerator.Clients.Config,
              {MemoGenerator.Clients.Config, :start_link, [nil, Test]}, :permanent, 5000, :worker,
              [MemoGenerator.Clients.Config]}
           ]
  end
end
