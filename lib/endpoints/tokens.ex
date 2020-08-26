defmodule Playlister.API.Tokens do
    use Plug.Router

    require Joken.Signer
    require Playlister.Utilities

    plug :match
    plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason
    plug :dispatch

    defp generate_token(user_id) do
        token = Playlister.Utilities.Tokens.generate_and_sign!(%{"user_id" => user_id})
        result = Postgrex.query!(DB, "INSERT INTO user_configs (user_id, token) VALUES ($1, $2) ON CONFLICT (user_id) DO UPDATE SET token = $2 RETURNING *", [user_id, token])
        {200, Jason.encode!(Enum.at(Playlister.Utilities.result_to_map(result), 0))}
    end

    post "/tokens/generate" do
        {status, response} =
                case conn.body_params do
                    %{"user_id" => user_id} -> generate_token(user_id)
                    _ -> {400, Jason.encode!(%{error: "no 'user_id' body argument provided."})}
                end
        send_resp(conn, status, response)
    end

    match _ do
        send_resp(conn, 404, "nothing here")
    end

end