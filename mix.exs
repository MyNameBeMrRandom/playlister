defmodule Dashboard.MixProject do
    use Mix.Project

    def project do
        [
            app: :playlister,
            version: "0.1.0",
            elixir: "~> 1.10",
            start_permanent: Mix.env() == :prod,
            deps: deps()
        ]
    end

    defp deps do
        [
            {:jason, "~> 1.2"},
            {:plug_cowboy, "~> 2.3.0"},
            {:postgrex, "~> 0.15.5"},
            {:timex, "~> 3.5"},
            {:joken, "~> 2.0"},
        ]
    end

    def application do
        [
            extra_applications: [:logger],
            mod: {Playlister, []}
        ]
    end

end
