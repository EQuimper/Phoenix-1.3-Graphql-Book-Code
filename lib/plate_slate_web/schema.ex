defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlate.{Menu, Repo}
  alias PlateSlateWeb.Resolvers

  import Ecto.Query

  import_types __MODULE__.MenuTypes

  query do
    @desc "The list of available items on the menu"
    field :menu_items, list_of(:menu_item) do
      arg :filter, :menu_item_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.menu_items/3
    end

    field :search, list_of(:search_result) do
      arg :matching, non_null(:string)
      resolve &Resolvers.Menu.search/3
    end
  end

  scalar :date do
    # parse the value to make it readable for elixir
    parse fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
        {:ok, date} <- Date.from_iso8601(value) do
          {:ok, date}
      else
        _ -> :error
      end
    end

    # get the elixir value and make it look nice for json
    serialize fn date ->
      Date.to_iso8601(date)
    end
  end

  enum :sort_order do
    value :asc
    value :desc
  end

end
