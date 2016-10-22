ActiveAdmin.register Attachment do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
	remove_filter :attachments_news

	permit_params :url, :file_size, :content_type

	controller do
    def create
      @attachment = Attachment.new(permitted_params[:attachment])

      if @attachment.save
        @attachment.news << News.where(id: params[:attachment][:news_ids])

        redirect_to admin_attachment_path(@attachment)
      else
      	render :new
      end
    end

    def new
    	@attachment = Attachment.new
    end

    def edit
    	@attachment = Attachment.eager_load(:news).find_by_id(params[:id])
    	@attachment.news_ids = @attachment.news.ids
    end

    def update
    	@attachment = Attachment.eager_load(:news).find_by_id(params[:id])

    	@attachment.update(permitted_params[:attachment])

      if @attachment.save
      	@attachment.news.clear
        @attachment.news << News.where(id: params[:attachment][:news_ids])

        redirect_to admin_attachment_path(@attachment)
      else
      	render :edit
      end
    end
  end

	form do |f|
	  f.semantic_errors # shows errors on :base
	  #f.inputs

	  f.inputs do
		  f.input :url
		  f.input :file_size, as: :number
		  f.input :content_type

	  	f.input :news, :as => :check_boxes, collection: f.object.generateSelectedNewsCollection
		end

	  f.actions         # adds the 'Submit' and 'Cancel' buttons
	end
end
