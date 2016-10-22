# The model of the object Follow
# Contain the relations
# It is only here for linked user to user, never an object Follow will be instanciate
class Follow < ActiveRecord::Base 
  belongs_to :user, 
    :class_name => 'User', :foreign_key => 'user_id' 
  belongs_to :user_to, 
    :class_name => 'User', :foreign_key => 'follow_id' 
end 
