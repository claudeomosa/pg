defmodule CustomerRecordParserTest do
  use ExUnit.Case, async: true

  alias CustomerRecordParser

  test "parse_csv_file/1 returns a list of customer records" do
    expected =
      {:ok,
       [
         ok: %{
           country_id: 1,
           dob: ~D[1990-01-01],
           name: "John Doe",
           national_id: "123456789",
           phone: "254722000000",
           site_code: 657
         },
         ok: %{
           country_id: 1,
           dob: ~D[1963-08-16],
           name: "Simon Kamau",
           national_id: "123456789",
           phone: "254705611231",
           site_code: 887
         }
       ]}

    assert CustomerRecordParser.parse_csv_file("test/fixtures/record.csv") == expected
  end

  test "parse_csv_file/1 returns an error for each invalid record" do
    expected =
      {:ok,
       [
         error: %{
           error: "Invalid phone number: 254722000000, country code does not match country code",
           line: 1
         },
         ok: %{
           country_id: 1,
           dob: ~D[1963-08-16],
           name: "Simon Kamau",
           national_id: "123456789",
           phone: "254705611231",
           site_code: 887
         },
         error: %{
           error: "Invalid country ID: 4",
           line: 3
         }
       ]}

    assert CustomerRecordParser.parse_csv_file("test/fixtures/record_with_error.csv") == expected
  end
end
