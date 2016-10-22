# The module contain every class from the API
# It is used for the routing (for the subdomain)
module API
  # The class is the parent of every class because it is inherit from 'Apisecurity'
  # ApiController > ApisecurityController > any class of the API
  # Thanks to this, every class has the param into an attribute (params[:xxxx] => @xxx)
  class ApiController < ActionController::Base
    protect_from_forgery with: :null_session
    skip_before_filter  :verify_authenticity_token
    before_action :setParamToObj
    before_action :cors_set_access_control_headers
    before_action :checkOptions

    # For all responses in this controller, return the CORS access control headers.
    def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Expose-Headers'] = 'ETag'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match,Auth-User-Token'
      headers['Access-Control-Allow-Credentials'] = 'true'
      headers['Access-Control-Max-Age'] = "1728000"
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

    # To render nothing in case of an option request (for Ajax)
    def checkOptions
      if request.options?
        render nothing: true and return
      end
    end
  end
end