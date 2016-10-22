module API
  # Controller which manage the transaction for the Influences objects
  # Here is the list of action available :
  #
  # * index       [get]
  class InfluencesController < ApisecurityController

    # Retrieve all the influences
    #
    # Route : /influences
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of influences including its genres
    # - +503+ - Error from server
    # 
    def index
    	begin
        if (@count.present? && @count == "true")
          @returnValue = { content: Influence.count }
        else
          @returnValue = { content: Influence.eager_load(:genres).all.as_json(:include => {
                                                            :genres => { :only => Genre.miniKey }
                                                          }, :only => Influence.miniKey) }
        end
        if (@returnValue[:content].size == 0)
          codeAnswer 202
        else
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end