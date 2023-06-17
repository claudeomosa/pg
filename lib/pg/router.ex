defmodule PG.Router do
  use Plug.Router
  require Logger

  plug(:match)
  plug(:dispatch)

  get "/" do
    {:ok, record} = CustomerRecordParser.parse_csv_file("test/fixtures/pg_records.csv")
    pg_records = Enum.map(record, fn {_key, value} -> value end)
    send_resp(conn, 200, Poison.encode!(%{"pg_records" => pg_records}))
  end

  get "/pg/valid_records" do
    {:ok, record} = CustomerRecordParser.parse_csv_file("test/fixtures/record.csv")
    valid_records = Enum.map(record, fn {_key, value} -> value end)
    send_resp(conn, 200, Poison.encode!(%{"valid_records" => valid_records}))
  end

  get "/pg/with_invalid_records" do
    {:ok, record} = CustomerRecordParser.parse_csv_file("test/fixtures/record_with_error.csv")

    valid_records =
      record
      |> Enum.filter(fn {key, _value} -> key == :ok end)
      |> Enum.map(fn {_key, value} -> value end)

    invalid_records =
      record
      |> Enum.filter(fn {key, _value} -> key == :error end)
      |> Enum.map(fn {_key, value} -> value end)

    send_resp(
      conn,
      200,
      Poison.encode!(%{"invalid_records" => invalid_records, "valid_records" => valid_records})
    )
  end

  match _ do
    send_resp(conn, 404, Poison.encode!(%{message: "Not found"}))
  end
end
