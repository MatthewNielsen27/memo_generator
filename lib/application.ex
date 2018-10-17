defmodule MemoGenerator.Application do
  @moduledoc """
  Module for application
  """
  use Application
  alias MemoGenerator.Clients.Setup

  def start(_type, args) do
    children = Setup.start(args)

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
