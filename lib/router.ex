defmodule Playlister.Router do
    use Plug.Router

    if Mix.env == :dev do
        use Plug.Debugger
    end

    plug Plug.Logger

    plug :match
    plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason
    plug :dispatch

    match "/playlists/*_", to: Playlister.API.Playlists
    match "/tokens/*_", to: Playlister.API.Tokens

    match _ do
        send_resp(conn, 404, "nothing here")
    end

end