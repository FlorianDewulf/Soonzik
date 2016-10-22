module API
  # Controller which manage the transaction for the Feedbacks objects
  # Here is the list of action available :
  #
  # * save       [post]
  class FeedbacksController < ApisecurityController


    # Save a new object Feedback. For more information on the parameters, check at the model
    # 
    # Route : /feedbacks/save
    #
    # ==== Options
    # 
    # * +:feedback [email]+ - Mail to contact
    # * +:feedback [type_object]+ - Type of the issue - Need to be one of this value : "bug", "payment", "account", "other"
    # * +:feedback [object]+ - Object of the feedback
    # * +:feedback [text]+ - Text of the feedback
    # 
    # ===== HTTP VALUE
    # 
    # - +201+ - In case of success, return nothing
    # - +503+ - Error from server, return nothing if there is an error from us, or the error why it didn't save
    # 
    def save
      begin
        feedback = Feedback.new(Feedback.feedback_params params)
        if (feedback.save)
          codeAnswer 201
          defineHttp :created
        else
          @returnValue = { content: feedback.errors.to_hash.to_json }
          codeAnswer 503
          defineHttp :service_unavailable
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end