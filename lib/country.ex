defmodule Country do
  defstruct [:name, :id, :sites]

  @type t :: %__MODULE__{
          name: String.t(),
          id: integer(),
          sites: list(integer())
        }

  def all_countries() do
    [
      %Country{
        name: "Kenya",
        id: 1,
        sites: [235, 657, 887]
      },
      %Country{
        name: "Sierra Leone",
        id: 2,
        sites: [772, 855]
      },
      %Country{
        name: "Nigeria",
        id: 3,
        sites: [465, 811, 980]
      }
    ]
  end
end
