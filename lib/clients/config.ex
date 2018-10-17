defmodule MemoGenerator.Clients.Config do
  @moduledoc """
  Agent to store state of API client configuration
  """
  use Agent

  def start_link(data, name) do
    initial =
      if is_map(data) do
        data
      else
        %{}
      end

    Agent.start_link(fn -> initial end, name: name)
  end

  @doc "Gets the value at key stored in agent"
  def get(pid, key) do
    Agent.get(pid, fn state -> Map.get(state, key) end)
  end

  @doc "Merges the input map with the current map"
  def update(pid, map) do
    if is_map(map) do
      Agent.update(pid, fn state -> Map.merge(state, map) end)
    else
      :error
    end
  end

  @doc "Resets the agent to store an empty map"
  def reset(pid) do
    Agent.update(pid, fn _state -> %{} end)
  end
end
