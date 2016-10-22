# The model of the object Ambiance
# Contain the relation and the validation
# Can provide some features linked to this model
#
# ==== Attributes
#
# - +id+ - (integer) - The ID of the object
# - +name+ - (string) - The name of the ambiance
#
# ==== Associations
#
# - +has_and_belongs_to_many+ - :musics
#
class Ambiance < ActiveRecord::Base
  has_and_belongs_to_many :musics, -> { where("album_id IS NOT NULL") }, class_name: 'Music', foreign_key: 'ambiance_id', join_table: 'ambiances_musics', association_foreign_key: 'music_id'

  def self.miniKey
  	[:id, :name]
  end
end