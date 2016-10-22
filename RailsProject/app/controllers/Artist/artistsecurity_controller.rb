
module Artist
  #
  # The class parent of every controller of the Artist Panel.
  # It provides security and some default stuff
  class ArtistsecurityController < ArtistsController
    before_action :initializeCtrl
    before_action :checkKey
    before_action :setParamToObj

    #
    # We create a list of code and initialize the returnValue and the security boolean.
    # Usually a controller has no constructor but in this case it's for the heritance.
    def initializeCtrl
      @security = false
      @returnValue = { content: {} }
      
      @code = []
      @code[200] = {code: 200, message: "Success"}
      @code[201] = {code: 201, message: "Created"}
      @code[202] = {code: 202, message: "NoContent"}
      @code[500] = {code: 500, message: "NotSecure"}
      @code[501] = {code: 501, message: "FailSecurity"}
      @code[502] = {code: 502, message: "NotFound"}
      @code[503] = {code: 503, message: "NotCreated"}
      @code[504] = {code: 504, message: "Error"}
      @code[505] = {code: 505, message: "UpdateError"}
    end

    #
    # Transform the params into attributes and create the getter to access it
    # 
    # ==== Options
    # 
    # * +params+ - The GET or POST params, it is provided by rails as a global value.
    def setParamToObj
      keys = params.keys

      keys.each do |x|
        self.instance_variable_set("@#{x.to_s}", params[x])
        self.class.class_eval do
          define_method("get#{x.to_s.capitalize}") { params[x] }
        end
      end
      @httpCode = nil
    end

protected
    #
    # Check if the secure key corresponds to the key of the selected user.
    # This key is the hash between the token and the salt user.
    #
    # ==== Options
    #
    # * +user_id+ - The id of the user who makes the transaction
    # * +secureKey+ - The key provided to etablish a secure transaction
    #
    # ==== Example
    #
    #     # Assuming we have in database a user like this :
    #     #<User> -> id = 9
    #             -> idAPI = "6789"
    #             -> salt = "12345"
    #             -> securekey = SHA256(salt + idAPI)
    #     So if I provide :
    #             -> user_id = 9
    #             -> secureKey = SHA256("123456789")
    #     The access is granted and secure.
    #     If the hash is not good, the access is not granted.
    #
    # ===== HTTP VALUE
    # 
    # It is not a route so you can't query it, but if an issue happend, it can set the http code
    # - +401+ - The combination user_id / secureKey doesn't match, the access is not granted
    # - +503+ - Error from server
    # 
    def checkKey
  		@u = nil

      if (params.has_key?(:user_id) && params.has_key?(:secureKey))
        begin
          u = User.find_by_id(params[:user_id])
          if (u != nil && params[:secureKey] == u.secureKey)
            @security = true
            if (Time.at(u.token_update).to_i < Time.now.to_i)
              u.regenerateKey
              u.save
            end
          else
            codeAnswer 501
          end
        rescue
          codeAnswer 504
          @httpCode = :service_unavailable
        end
      end

  		if user_signed_in?
  			@u = current_user
  		elsif @security
  			@u = User.find_by_id(params[:user_id])
  		end

      if (@u == nil || (@u && !@u.isArtist?))
        redirect_to root_url subdomain: false
      end
    end


    #
    # Render the value to return in json
    def sendJson
      codeAnswer(202) if defined?(@returnValue[:content]) && defined?(@returnValue[:content].size) && @returnValue[:content].size == 0 && !defined?@returnValue[:code]
      defineHttp :ok if @httpCode == nil
      render :json => JSON.generate(@returnValue), :status => @httpCode
    end

    #
    # Put information about the answer (the code and the corresponding message) in the return value.
    # If a code has already been assigned, we don't modify it.
    #
    # ==== Attributes
    #
    # * +index+ - The index of the answer information
    #
    def codeAnswer(index)
      if (@code[index] != nil)
        @returnValue[:code] = @code[index][:code]
        @returnValue[:message] = @code[index][:message]
      else
        @returnValue[:code] = 999
        @returnValue[:message] = "Unknow"
      end
    end

    #
    # Set the HTTP status
    # If a code has already been assigned, we don't modify it.
    #
    # ==== Attributes
    #
    # * +sym+ - The symbol of the http code
    #
    def defineHttp(sym)
      @httpCode = sym
    end
  end
end