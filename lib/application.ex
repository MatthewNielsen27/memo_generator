defmodule MemoGenerator.Application do
    @moduledoc """
    Module for application
    """
    use Application

    def start(_type, args) do    
        children = MemoGenerator.Clients.Setup.start(args)
    
        Supervisor.start_link(children, strategy: :one_for_one)
    end
end
