WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.

  #namespace :notifications do
  #  subscribe :notify, :to => "NotificationsController", :with_method => :create
  #end
  
  namespace :messages do
    subscribe :send, :to => MessagesController, :with_method => :sendMsg
  end
  
  namespace :websocket_rails do
    subscribe :pong, :to => MessagesController, :with_method => :pong
  end

  # The :client_connected method is fired automatically when a new client connects
  subscribe :client_connected, :to => MessagesController, :with_method => :client_connected
  # The :client_disconnected method is fired automatically when a client disconnects
  subscribe :client_disconnected, :to => MessagesController, :with_method => :delete_user

  subscribe :who_is_online, :to => MessagesController, :with_method => :getOnlineFriend
  subscribe :init_connection, :to => MessagesController, :with_method => :init_smartphone_connection
end
