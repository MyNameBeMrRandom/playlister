defmodule Playlister.Utilities do

    def result_to_map(%Postgrex.Result{columns: column_names, rows: rows}) do
        Enum.map(rows, fn(row) -> Stream.zip(column_names, row) |> Enum.into(Map.new(), &(&1)) end)
    end

end