defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlate.{Menu, Repo}
  alias PlateSlateWeb.Resolvers
  alias PlateSlateWeb.Schema.Middleware

  import Ecto.Query

  import_types __MODULE__.MenuTypes
  import_types __MODULE__.OrderingTypes

  query do
    @desc "The list of available items on the menu"
    field :menu_items, list_of(:menu_item) do
      arg :filter, :menu_item_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.menu_items/3
    end

    field :categories, list_of(:category) do
      resolve &Resolvers.Menu.categories/3
    end

    field :search, list_of(:search_result) do
      arg :matching, non_null(:string)
      resolve &Resolvers.Menu.search/3
    end
  end

  mutation do
    field :create_menu_item, :menu_item_result do
      arg :input, non_null(:menu_item_input)
      resolve &Resolvers.Menu.create_item/3
      middleware Middleware.ChangesetErrors
    end

    field :place_order, :order_result do
      arg :input, non_null(:place_order_input)
      resolve &Resolvers.Ordering.place_order/3
    end

    field :ready_order, :order_result do
      arg :id, non_null(:id)
      resolve &Resolvers.Ordering.ready_order/3
    end

    field :complete_order, :order_result do
      arg :id, non_null(:id)
      resolve &Resolvers.Ordering.complete_order/3
    end
  end

  subscription do
    field :new_order, :order do
      config fn _args, _info ->
        {:ok, topic: "*"}
      end

      resolve fn root, _, _ ->
        IO.inspect(root)
        {:ok, root}
      end
    end

    field :update_order, :order do
      arg :id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.id}
      end

      trigger [:ready_order, :complete_order], topic: fn
        %{order: order} -> [to_string(order.id)]
        _ -> []
      end

      resolve fn %{order: order}, _, _ ->
        {:ok, order}
      end
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

  scalar :decimal do
    parse fn
      %{value: value}, _ ->
        Decimal.parse(value)
      _, _ ->
        :error
    end

    serialize &to_string/1
  end

  enum :sort_order do
    value :asc
    value :desc
  end

  @desc "An error encountered trying to persist input"
  object :input_error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end

end
