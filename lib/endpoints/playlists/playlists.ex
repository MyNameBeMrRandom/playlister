defmodule Playlister.API.Playlists do
    use Plug.Router

    use Timex
    require Playlister.Utilities

    plug :match
    plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason
    plug :dispatch

    defp create_playlist(title, owner_id) do
        result = Postgrex.query!(DB, "INSERT INTO playlists (owner_id, title, image, created_at) VALUES ($1, $2, $3, $4) RETURNING *", [owner_id, title, "", Timex.now])
        {200, Jason.encode!(Enum.at(Playlister.Utilities.result_to_map(result), 0))}
    end

    post "/playlists" do
        {status, response} =
                case conn.body_params do
                    %{"title" => title, "owner_id" => owner_id} -> create_playlist(title, owner_id)
                    _ -> {400, Jason.encode!(%{error: ""})}
                end
        send_resp(conn, status, response)
    end

    match _ do
        send_resp(conn, 404, "nothing here")
    end

end