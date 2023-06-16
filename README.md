## PG

***A program that takes a CSV file as input, and returns either a Customer record or an error for each row***

### iex Usage
* Run `mix deps.get` to install dependencies
* Run tests with  `mix test`
* The following example shows how to parse a CSV file, open `iex` with `iex -S mix`
* You can also run `h CustomerRecordParser.parse_csv_file` in `iex`

```elixir
{:ok, records} = CustomerRecordParser.parse_csv_file("test/fixtures/record.csv")
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

### HTTP
 * Run `mix deps.get` to install dependencies
 * Run tests with  `mix test`
 * Run `mix run --no-halt` to start a minimalistic plug-based web server
 
 * Visit [`localhost:4000/pg/valid_records`](http://localhost:4000/pg/valid_records) . To get a test record with only valid records.
 * Visit [`localhost:4000/pg/with_invalid_records`](http://localhost:4000/pg/with_invalid_records) .  To get a test record with dirty records.

**Endpoints**

```http
    GET /pg/valid_records 
```
```http
    GET /pg/with_invalid_records
```
