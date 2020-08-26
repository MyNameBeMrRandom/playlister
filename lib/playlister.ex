defmodule Playlister do
    use Application

    require Logger

    def start(_type, _args) do
        Logger.info('[MAIN] Starting API')

        children = [
            {Postgrex, Keyword.put(Application.get_env(:playlister, :database), :name, DB)},
            Plug.Cowboy.child_spec(
                scheme: :http,
                plug: Playlister.Router,
                options: [
                    port: 8000
                ]
            ),
        ]

        options = [strategy: :one_for_one, name: Playlists.Supervisor]
        Supervisor.start_link(children, options)
    end

end
