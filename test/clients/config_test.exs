defmodule MemoGenerator.Clients.ConfigTest do
    use ExUnit.Case

    test "Config start_link/2 handles valid map" do
        data = %{
            "token" => "12dahbd31jdn31i23=2s",
            "base_url" => "www.example.com"
        }

        assert {:ok, pid} = MemoGenerator.Clients.Config.start_link(data, Client)
    end

    test "Config start_link/2 handles invalid map" do
        data = []

        assert {:ok, pid} = MemoGenerator.Clients.Config.start_link(data, Client)
    end

    test "Get data using Config get/2" do
        data = %{
            "token" => "12dahbd31jdn31i23=2s",
            "base_url" => "www.example.com"
        }

        assert {:ok, pid} = MemoGenerator.Clients.Config.start_link(data, Client)
        assert MemoGenerator.Clients.Config.get(Client, "token") == "12dahbd31jdn31i23=2s"
        assert MemoGenerator.Clients.Config.get(Client, "base_url") == "www.example.com"
        assert MemoGenerator.Clients.Config.get(Client, "headers") == nil
    end

    test "Reset data using Config reset/1" do
        data = %{
            "token" => "12dahbd31jdn31i23=2s",
            "base_url" => "www.example.com"
        }

        assert {:ok, pid} = MemoGenerator.Clients.Config.start_link(data, Client)
        assert MemoGenerator.Clients.Config.get(Client, "token") == "12dahbd31jdn31i23=2s"
        assert MemoGenerator.Clients.Config.reset(Client) == :ok
        assert MemoGenerator.Clients.Config.get(Client, "token") == nil
    end

    test "Update data with valid map using Config update/2" do
        data_1 = %{
            "token" => "12dahbd31jdn31i23=2s"
        }
        data_2 = %{
            "base_url" => "www.example.com"
        }

        assert {:ok, pid} = MemoGenerator.Clients.Config.start_link(data_1, Client)
        assert MemoGenerator.Clients.Config.get(Client, "token") == "12dahbd31jdn31i23=2s"
        refute MemoGenerator.Clients.Config.get(Client, "base_url") == "www.example.com"
        assert MemoGenerator.Clients.Config.update(Client, data_2) == :ok
        assert MemoGenerator.Clients.Config.get(Client, "token") == "12dahbd31jdn31i23=2s"
        assert MemoGenerator.Clients.Config.get(Client, "base_url") == "www.example.com"
    end
end
