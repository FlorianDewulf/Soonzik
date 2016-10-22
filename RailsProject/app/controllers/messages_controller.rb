class MessagesController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    controller_store[:user_id] = []
    controller_store[:lock_sql] = false
  end

  def client_connected
    if !user_signed_in?
      controller_store[:user_id] << { id: nil, socket: self.connection }
    else
      controller_store[:user_id] << { id: current_user.id, socket: self.connection }
      current_user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          if friend.id == connected_guy[:id]
            connected_guy[:socket].send_message('newOnlineFriends', { :idFriend => current_user.id }.to_json)
          end
        }
      }
    end
  end

  def init_smartphone_connection
    @user = nil
    begin
      @user = Message.checkKey(message, (user_signed_in?) ? current_user : nil)
    rescue
    end
    if @user != nil
      isConnected = false
      controller_store[:user_id].each_with_index { |user, index|
        if (user[:socket] == self.connection)
          user[:id] = @user.id
          isConnected = true
          break
        end
      }
      controller_store[:user_id] << { id: @user.id, socket: self.connection } if !isConnected
      @user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          if friend.id == connected_guy[:id]
            connected_guy[:socket].send_message('newOnlineFriends', { :idFriend => @user.id }.to_json)
          end
        }
      }
    end
  end

  def delete_user
    user_id = nil
    controller_store[:user_id].each_with_index { |user, index|
      if (user[:socket] == self.connection || (message.has_key?(:user_id) && user[:user_id] == message[:user_id]))
        user_id = user[:id]
        controller_store[:user_id].delete_at(index)
        break
      end
    }
    if (user_id != nil && (u = User.find_by_id(user_id)))
      u.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          if friend.id == connected_guy[:id]
            connected_guy[:socket].send_message('newOfflineFriends', { :idFriend => user_id }.to_json)
          end
        }
      }
    end
  end

  def sendMsg
    @user = nil
    begin
      @user = Message.checkKey(message, (user_signed_in?) ? current_user : nil)
    rescue
    end
    if (@user != nil && defined?message["toWho"])
      target = User.find_by_id(message["toWho"]);
      if (target != nil)
        newMsg = Message.new
        newMsg.msg = message["messageValue"]
        newMsg.user_id = @user.id
        newMsg.dest_id = target.id
        newMsg.save!
        controller_store[:user_id].each_with_index { |user, index|
          if (user[:id] == target.id)
            user[:socket].send_message('newMsg', { message: message["messageValue"], from: @user.username }.to_json)
            break
          end
        }
      end
    end
  end

  def getOnlineFriend
    @user = nil
    begin
      @user = Message.checkKey(message, (user_signed_in?) ? current_user : nil)
    rescue
    end
    friends = []
    if (@user != nil)
      u = nil
      @user.friends.each { |friend|
        controller_store[:user_id].each { |connected_guy|
          friends << connected_guy[:id] if friend.id == connected_guy[:id]
        }
      }
      controller_store[:user_id].each_with_index { |user, index|
        if (user[:id] == @user.id)
          user[:socket].send_message('onlineFriends', {:message => friends}.to_json)
          break
        end
      }
    end
  end

  def pong
    if (controller_store[:lock_sql] == false)
      controller_store[:lock_sql] = true
      Chatjob.where("created_at < ?", Time.now - 120).delete_all
      Chatjob.all.each do |job|
        msg = Message.eager_load(:sender).find_by_id(job.message_id)
        controller_store[:user_id].each { |user|
          if (user[:id] == msg.dest_id)
            user[:socket].send_message('newMsg', { message: msg.msg, from: msg.sender.username }.to_json)
            break
          end
        }
      end
      Chatjob.all.delete_all
      controller_store[:lock_sql] = false
    end
  end
end
