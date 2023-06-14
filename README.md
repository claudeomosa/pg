# PG

**A program that takes a CSV file as input, and returns either a Customer record or an error for each row**

## Usage

The following exapmle shows how to parse a CSV file

```elixir
{:ok, records} = CustomerRecordParser.parse_csv_file("test/fixtures/customers.csv")
#=> {:ok,[
#=>   ok: %{
#=>     country_id: 2,
#=>     dob: ~D[1990-01-01],
#=>     name: "John Doe",
#=>     national_id: "123456789",
#=>     phone: "254722000000",
#=>     site_code: 772
#=>     },
#=>   ]
#=> }
```