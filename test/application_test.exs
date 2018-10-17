defmodule MemoGenerator.ApplicationTest do
    use ExUnit.Case
    
    test "application startup with one client" do
        assert {:ok, _pid} = MemoGenerator.Application.start(:normal, [:jira])
    end
end