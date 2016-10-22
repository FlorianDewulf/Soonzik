module API
  # Controller which manage the transaction for the Packs objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  #
  class PacksController < ApisecurityController
    # Retrieve all the packs
    #
    # Route : /packs
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of pack including its albums which includes its musics and the user (artist)
    # - +503+ - Error from server
    # 
    def index
      begin
        if (@count.present? && @count == "true")
          @returnValue = { content: Pack.count }
        else
          p = Pack.eager_load([albums: { user: {}, musics: {} }, user: {}, descriptions: {}, partial_albums: {}]).all
          p.each do |pack|
            Album.fillLikes pack.albums, @security, @user_id
          end
          @returnValue = { content: p.as_json(:include => { albums: {
              :include => {
                :user => { :only => User.miniKey },
                :musics => { :only => Music.miniKey }
              },
              :only => Album.miniKey,
              methods: [:likes, :hasLiked]
            },
            user: {
              :only => User.miniKey
            },
            descriptions: {
              :only => Description.miniKey
            },
            partial_albums: {
              :only => PartialAlbum.miniKey
            }
          }, :only => Pack.miniKey, methods: :averagePrice) }
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

    # Give a specific object by its id
    #
    # Route : /packs/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific pack
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a pack including its albums which includes its musics and the user (artist)
    # - +404+ - Can't find the packs, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        pack = Pack.eager_load([albums: { user: {}, musics: {} }, user: {}, descriptions: {}, partial_albums: {}]).find_by_id(@id)
        if (!pack)
          codeAnswer 502
          defineHttp :not_found
        else
          pack.albums.each do |album|
            album.setPack(pack.id)
          end
          Album.fillLikes pack.albums, @security, @user_id
          @returnValue = { content: pack.as_json(:include => { albums: {
                                                                  :include => {
                                                                    :user => { :only => User.miniKey },
                                                                    :musics => { :only => Music.miniKey }
                                                                  },
                                                                  :only => Album.miniKey,
                                                                  methods: [:likes, :hasLiked, :isPartial]
                                                                },
                                                                user: {
                                                                  :only => User.miniKey
                                                                },
                                                                descriptions: {
                                                                  :only => Description.miniKey
                                                                },
                                                                partial_albums: {
                                                                  :only => PartialAlbum.miniKey
                                                                }
                                                              }, :only => Pack.miniKey, methods: :averagePrice) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Give a part of the packs depending of the filter passed into parameter
    #
    # Route : /packs/find
    #
    # ==== Options
    # 
    # * +attribute [attribute_name]+ - If you want a column equal to a specific value
    # * +order_by_asc []+ - If you want to order by ascending by values
    # * +order_by_desc []+ - If you want to order by descending by values
    # * +group_by []+ - If you want to group by field
    # * +limit+ - The number of row you want
    # * +offset+ - The offset of the array
    # 
    # ==== Example
    #
    #     http://api.soonzik.com/packs/find?attribute[style]=rock&order_by_desc[]=id&group_by[]=title
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of packs including its albums which includes its musics and user (artist)
    # - +503+ - Error from server
    # 
    def find
      begin
        pack_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'packs'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (pack_object == nil)          #pack_object doesn't exist
              pack_object = Pack.eager_load([albums: { user: {}, musics: {} }, user: {}, descriptions: {}, partial_albums: {}]).where(condition)
            else                              #pack_object exists
              pack_object = pack_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          pack_object = Pack.eager_load([albums: { user: {}, musics: {} }, user: {}, descriptions: {}, partial_albums: {}]).all            #no attribute specified
        end

        order_asc = ""
        order_desc = ""
        # filter the order by asc to create the string
        if (defined?@order_by_asc)
          @order_by_asc.each do |x|
            order_asc += ", " if order_asc.size != 0
            order_asc += ("'packs'." + %Q[#{x}] + " ASC")
          end
        end
        # filter the order by desc to create the string
        if (defined?@order_by_desc)
          @order_by_desc.each do |x|
            order_desc += ", " if order_desc.size != 0
            order_desc += ("'packs'." + %Q[#{x}] + " DESC")
          end
        end

        if (order_asc.size > 0 && order_desc.size > 0)
          pack_object = pack_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          pack_object = pack_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          pack_object = pack_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          pack_object = pack_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          pack_object = pack_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          pack_object = pack_object.offset(@offset.to_i)
        end

        pack_object.each do |pack|
          Album.fillLikes pack.albums, @security, @user_id
        end

        @returnValue = { content: pack_object.as_json(:include => { albums: {
                                                                              :include => {
                                                                                            :user => { :only => User.miniKey },
                                                                                            :musics => { :only => Music.miniKey }
                                                                                          },
                                                                              :only => Album.miniKey,
                                                                              methods: [:likes, :hasLiked]
                                                                            },
                                                                  user: {
                                                                    :only => User.miniKey
                                                                  },
                                                                  descriptions: {
                                                                    :only => Description.miniKey
                                                                  },
                                                                  partial_albums: {
                                                                    :only => PartialAlbum.miniKey
                                                                  }
                                                                  }, :only => Pack.miniKey, methods: :averagePrice) }

        if (pack_object.size == 0)
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