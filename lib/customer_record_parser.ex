defmodule CustomerRecordParser do
  @moduledoc """
    Documentation for `CustomerRecordParser`.
    This module is responsible for parsing customer records from a CSV file.
  """

  @countries [
    %{
      name: "Kenya",
      id: 1,
      sites: [235, 657, 887]
    },
    %{
      name: "Sierra Leone",
      id: 2,
      sites: [772, 855]
    },
    %{
      name: "Nigeria",
      id: 3,
      sites: [465, 811, 980]
    }
  ]

  @spec parse_csv_file(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: {:error, <<_::152>>} | {:ok, list}
  @doc """
    Parses a CSV file and returns a list of customer records and an error for each invalid record.
    Returns an error if the file does not exist.

    ## Examples

        iex> CustomerRecordParser.parse_csv_file("test/fixtures/customers.csv")
        {:ok, [
          ok: %{
            country_id: 1,
            dob: ~D[1990-01-01],
            name: "John Doe",
            national_id: "123456789",
            phone: "254722000000",
            site_code: 235
          },
          ok: %{
            country_id: 1,
            dob: ~D[1990-01-01],
            name: "Jane Doe",
            national_id: "123456789",
            phone: "254722000000",
            site_code: 235
          }
          error: %{
            error: "Invalid country ID: 4",
            line: 3
          }
        ]}
        iex> CustomerRecordParser.parse_csv_file("test/fixtures/missing_file.csv")
        {:error, "File does not exist"}
  """

  def parse_csv_file(file_path) do
    if File.exists?(file_path) do
      record =
        file_path
        |> File.stream!()
        |> CSV.decode(headers: true)
        |> Enum.into([])
        |> Enum.with_index()
        |> Enum.map(&parse_customer_record/1)

      {:ok, record}
    else
      {:error, "File does not exist"}
    end
  end

  defp parse_customer_record({{_key, row}, index}) do
    case validate_customer_fields(row) do
      {:ok, customer_fields} -> {:ok, customer_fields}
      {:error, error_msg} -> {:error, %{error: error_msg, line: index + 1}}
    end
  end

  defp validate_customer_fields(row) do
    %{
      "Name" => name,
      "DoB" => dob,
      "Phone" => phone,
      "NationalID" => national_id,
      "CountryID" => country_id,
      "SiteCode" => site_code
    } = row

    with {:ok, parsed_dob} <- parse_date_of_birth(dob),
         {:ok, parsed_phone} <- parse_telephone_number(phone),
         {:ok, parsed_country_id} <- parse_country_id(country_id),
         {:ok, parsed_site_code} <- parse_site_code(parsed_country_id, site_code),
         {:ok, name} <- verify_name(name) do
      {:ok,
       %{
         name: name,
         dob: parsed_dob,
         phone: parsed_phone,
         national_id: national_id,
         country_id: parsed_country_id,
         site_code: parsed_site_code
       }}
    else
      {:error, error_msg} -> {:error, error_msg}
    end
  end

  defp verify_name(name) do
    if name == "" do
      {:error, "Name cannot be empty."}
    else
      {:ok, name}
    end
  end

  defp parse_date_of_birth(dob) do
    if dob == "" do
      {:error, "Date of birth cannot be empty."}
    else
      case Date.from_iso8601(dob) do
        {:ok, parsed_dob} ->
          if parsed_dob > Date.utc_today() do
            {:error, "Date of birth cannot be in the future: #{dob}"}
          else
            {:ok, parsed_dob}
          end

        _ ->
          {:error, "Invalid date of birth: #{dob}"}
      end
    end
  end

  defp parse_telephone_number(phone) do
    if phone != "" do
      number = String.replace(phone, "+", "")
      pattern = ~r/^[a-zA-Z]+$/

      if Regex.match?(pattern, number) do
        {:error, "Invalid phone number: #{phone}"}
      else
        {:ok, number}
      end
    else
      {:error, "Phone number cannot be empty."}
    end
  end

  defp parse_country_id(country_id) do
    if country_id == "" do
      {:error, "Country ID cannot be empty."}
    else
      case String.to_integer(country_id) do
        id ->
          case Enum.find(@countries, fn country -> country.id == id end) do
            nil -> {:error, "Invalid country ID: #{country_id}"}
            country -> {:ok, country.id}
          end
      end
    end
  end

  defp parse_site_code(country_id, site_code) do
    if site_code != "" do
      parsed_site_code = String.to_integer(site_code)

      country_name = Enum.find(@countries, fn country -> country.id == country_id end).name

      case Enum.find(@countries, &site_belongs_to_country?(&1, country_id, parsed_site_code)) do
        nil -> {:error, "Site code #{site_code} does not exist in #{country_name}."}
        _ -> {:ok, parsed_site_code}
      end
    else
      {:error, "Site Code cannot be empty."}
    end
  end

  defp site_belongs_to_country?(country, country_id, site_code) do
    country.id == country_id and site_code in country.sites
  end
end
