module FormatsHelper
  def format_get_params(arr)
  	returnValue = "?"
  	i = 0
  	arr.each_pair do |key, value|
  		returnValue += URI.escape(key.to_s) + "=" + URI.escape(value.to_s)
  		unless (i == arr.size - 1)
  			returnValue += "&"
  		end
  		i += 1
  	end
  	return returnValue
  end
end