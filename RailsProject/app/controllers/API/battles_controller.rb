module API
  # Controller which manage the transaction for the Battles objects
  # Here is the list of action available :
  #
  # * index       [get]
  # * show        [get]
  # * find        [get]
  # * vote        [post] - SECURE
  #
  class BattlesController < ApisecurityController
  	# Retrieve all the battles
    #
    # Route : /battles
    #
    # ==== Options
    # 
    # * +count+ - (optionnal) Get the number of object and not the object themselve. Useful for pagination
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of battles including the artists and the vote
    # - +503+ - Error from server
    # 
    def index
      begin
        if (@count.present? && @count == "true")
          @returnValue = { content: Battle.count }
        else
          @returnValue = { content: Battle.eager_load([:artist_one, :artist_two, :votes]).all.as_json(:include => {
        														:artist_one => { :only => User.miniKey },
        														:artist_two => { :only => User.miniKey },
        														:votes      => { :only => Vote.miniKey }
        													}, :only => Battle.miniKey ) }
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
    # Route : /albums/:id
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific battle
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the specific battle
    # - +404+ - Can't get the battle, the id is probably wrong
    # - +503+ - Error from server
    # 
    def show
      begin
        battle = Battle.eager_load([:artist_one, :artist_two, :votes]).find_by_id(@id)
        if (!battle)
          codeAnswer 502
          defineHttp :not_found
        else
          @returnValue = { content: battle.as_json(:include => {
          														:artist_one => { :only => User.miniKey },
          														:artist_two => { :only => User.miniKey },
          														:votes => { :only => Vote.miniKey }
          													}, :only => Battle.miniKey) }
          codeAnswer 200
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end

    # Give a part of the battles depending of the filter passed into parameter
    #
    # Route : /battles/find
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
    #     http://api.soonzik.com/battles/find?attribute[artist_one_id]=1&order_by_desc[]=artist_two_id&group_by[]=artist_one_id
    #     Note : By default, if you precise no attribute, it will take every row
    #
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return a list of battles including its artists and the votes
    # - +503+ - Error from server
    # 
    def find
      begin
        battle_object = nil
        if (defined?@attribute)
          # - - - - - - - -
          @attribute.each do |x, y|
            condition = ""
            if (y[0] == "%" && y[-1] == "%")  #LIKE
              condition = ["'battles'.? LIKE ?", %Q[#{x}], "%#{y[1...-1]}%"];
            else                              #WHERE
              condition = {x => y};
            end

            if (battle_object == nil)          #battle_object doesn't exist
              battle_object = Battle.eager_load([:artist_one, :artist_two, :votes]).where(condition)
            else                              #battle_object exists
              battle_object = battle_object.where(condition)
            end
          end
          # - - - - - - - -
        else
          battle_object = Battle.eager_load([:artist_one, :artist_two, :votes]).all            #no attribute specified
        end

        order_asc = ""
        order_desc = ""
        # filter the order by asc to create the string
        if (defined?@order_by_asc)
          @order_by_asc.each do |x|
            order_asc += ", " if order_asc.size != 0
            order_asc += ("'battles'." + %Q[#{x}] + " ASC")
          end
        end
        # filter the order by desc to create the string
        if (defined?@order_by_desc)
          @order_by_desc.each do |x|
            order_desc += ", " if order_desc.size != 0
            order_desc += ("'battles'." + %Q[#{x}] + " DESC")
          end
        end

        if (order_asc.size > 0 && order_desc.size > 0)
          battle_object = battle_object.order(order_asc + ", " + order_desc)
        elsif (order_asc.size == 0 && order_desc.size > 0)
          battle_object = battle_object.order(order_desc)
        elsif (order_asc.size > 0 && order_desc.size == 0)
          battle_object = battle_object.order(order_asc)
        end

        if (defined?@group_by)    #group
          group = []
          @group_by.each do |x|
            group << %Q[#{x}]
          end
          battle_object = battle_object.group(group.join(", "))
        end

        if (defined?@limit)       #limit
          battle_object = battle_object.limit(@limit.to_i)
        end
        if (defined?@offset)      #offset
          battle_object = battle_object.offset(@offset.to_i)
        end

        @returnValue = { content: battle_object.as_json(:include => {
                                    :artist_one => { :only => User.miniKey },
                                    :artist_two => { :only => User.miniKey },
                                    :votes => { :only => Vote.miniKey }
                                  }, :only => Battle.miniKey) }

        if (battle_object.size == 0)
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

    # To vote for a specific battle
    #
    # Route : /battles/:id/vote
    #
    # ==== Options
    # 
    # * +id+ - The id of the specific battle
    # * +artist_id+ - The id of the artist you want to vote for
    # 
    # ===== HTTP VALUE
    # 
    # - +200+ - In case of success, return the specific battle
    # - +404+ - Can't get the battle, the id is probably wrong
    # - +503+ - Error from server
    # 
    def vote
      begin
        if (@security)
          battle = Battle.find_by_id(@id)
          if (!battle || (battle &&
                          @artist_id.to_i != battle.artist_one_id &&
                          @artist_id.to_i != battle.artist_two_id))
            codeAnswer 502
            defineHttp :not_found
          else
            oldVote = Vote.eager_load([:battle => { votes: {} }, artist: {}]).where(battle_id: @id).find_by_user_id(@user_id)
            if (oldVote)
              oldVote.artist_id = @artist_id
              oldVote.save!
              codeAnswer 200
              defineHttp :ok
            else
              # I use oldVote to keep the scope variable and to easily return it
              oldVote = Vote.new
              oldVote.user_id = @user_id
              oldVote.battle_id = @id
              oldVote.artist_id = @artist_id
              oldVote.save!
              codeAnswer 201
              defineHttp :created
            end
            @returnValue[:content] = oldVote.as_json(only: [:id], :include => {
              battle: { only: Battle.miniKey, :include => {
                  :votes => { :only => Vote.miniKey }
                }
              },
              artist: { only: User.miniKey }
            })
          end
        else
          codeAnswer 500
          defineHttp :forbidden
        end
      rescue
        codeAnswer 504
        defineHttp :service_unavailable
      end
      sendJson
    end
  end
end