module API
  # Controller which manage the transaction for the Albums objects
  # Here is the list of action available :
  #
  # * index       [get]
  #
  class LanguagesController < ApisecurityController
    #
    # Retrieve all the languages
    #
    # Route : /languages
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of languages
    # - +503+ - Error from server
    # 
    def index
      begin
        @returnValue = { content: Language.all.as_json(only: [:id, :language, :abbreviation]) }
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