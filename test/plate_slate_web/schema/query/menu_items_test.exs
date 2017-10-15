defmodule PlateSlateWeb.Schema.Query.MenuItemsTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    Code.load_file("priv/repo/seeds.exs")
  end

  # @query """
  # {
  #   menuItems {
  #     name
  #   }
  # }
  # """
  #
  # @query2 """
  # {
  #   menuItems(matching: "rue") {
  #     name
  #   }
  # }
  # """
  #
  # @query3 """
  # {
  #   menuItems(matching: "pa  ") {
  #     name
  #   }
  # }
  # """
  #
  # @query4 """
  # {
  #   menuItems(matching: 123) {
  #     name
  #   }
  # }
  # """
  #
  # @query5 """
  # query ($term: String) {
  #   menuItems(matching: $term) {
  #     name
  #   }
  # }
  # """
  #
  # @query6 """
  # {
  #   menuItems(order: DESC) {
  #     name
  #   }
  # }
  # """
  #
  # @variables %{"term" => "rue"}
  #
  # test "menuItems field returns menu items" do
  #   response = get(build_conn(), "/api", query: @query)
  #   assert json_response(response, 200) == %{
  #     "data" => %{
  #       "menuItems" => [
  #         %{"name" => "Bánh mì"},
  #         %{"name" => "Chocolate Milkshake"},
  #         %{"name" => "Croque Monsieur"},
  #         %{"name" => "French Fries"},
  #         %{"name" => "Lemonade"},
  #         %{"name" => "Masala Chai"},
  #         %{"name" => "Muffuletta"},
  #         %{"name" => "Papadum"},
  #         %{"name" => "Pasta Salad"},
  #         %{"name" => "Rueben"},
  #         %{"name" => "Soft Drink"},
  #         %{"name" => "Vada Pav"},
  #         %{"name" => "Vanilla Milkshake"},
  #         %{"name" => "Water"},
  #       ]
  #     }
  #   }
  # end
  #
  # test "menuItems field returns menu items filtered by name" do
  #   response = get(build_conn(), "/api", query: @query2)
  #   assert json_response(response, 200) == %{
  #     "data" => %{
  #       "menuItems" => [
  #         %{"name" => "Rueben"}
  #       ]
  #     }
  #   }
  # end
  #
  # test "menuItems field returns menu items filtered by name, also trim the matching argument" do
  #   response = get(build_conn(), "/api", query: @query3)
  #   assert json_response(response, 200) == %{
  #     "data" => %{
  #       "menuItems" => [
  #         %{"name" => "Papadum"},
  #         %{"name" => "Pasta Salad"},
  #         %{"name" => "Vada Pav"},
  #       ]
  #     }
  #   }
  # end
  #
  # test "menuItems field returns menuItems filtered by name when using a variable" do
  #   response = get(build_conn(), "/api", query: @query5, variables: @variables)
  #   assert json_response(response, 200) == %{
  #     "data" => %{
  #       "menuItems" => [
  #         %{"name" => "Rueben"}
  #       ]
  #     }
  #   }
  # end
  #
  # test "menuItems field returns errors when using a bad value" do
  #   response = get(build_conn(), "/api", query: @query4)
  #   assert %{"errors" => [
  #     %{"message" => message}
  #     ]} = json_response(response, 400)
  #
  #   assert message == "Argument \"matching\" has invalid value 123."
  # end
  #
  # test "menuItems field returns menuItems descending when asked using literals" do
  #   response = get(build_conn(), "/api", query: @query6)
  #   assert %{
  #     "data" => %{
  #       "menuItems" => [
  #         %{"name" => "Water"} | _
  #       ]
  #     }
  #   } = json_response(response, 200)
  # end

  @query7 """
  {
    menuItems(filter: {category: "Sandwiches", tag: "Vegetarian"}) {
      name
    }
  }
  """

  test "menuItems field returns menuItems, filtering with a literal" do
    response = get(build_conn(), "/api", query: @query7)
    assert %{
      "data" => %{"menuItems" => [
        %{"name" => "Vada Pav"}
      ]}
    } == json_response(response, 200)
  end

end
