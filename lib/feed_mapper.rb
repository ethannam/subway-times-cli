class FeedMapper
  def map(route_short_name)
    if route_short_name == "1" || route_short_name == "2" || route_short_name == "3" || route_short_name == "4" || route_short_name == "5" || route_short_name == "6"
      return 1
    elsif route_short_name == "A" || route_short_name == "C" || route_short_name == "E" || route_short_name == "H" || route_short_name == "S"
      return 26
    elsif route_short_name == "N" || route_short_name == "Q" || route_short_name == "R" || route_short_name == "W"
      return 16
    elsif route_short_name == "B" || route_short_name == "D" || route_short_name == "F" || route_short_name == "M"
      return 21
    elsif route_short_name == "L"
      return 2
    elsif route_short_name == "SIR"
      return 11
    elsif route_short_name == "G"
      return 31
    elsif route_short_name == "J" || route_short_name == "Z"
      return 36
    elsif route_short_name == "7"
      return 51
    else
      return false
    end
  end
end