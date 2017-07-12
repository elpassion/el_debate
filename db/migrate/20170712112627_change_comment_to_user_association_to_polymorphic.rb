class ChangeCommentToUserAssociationToPolymorphic < ActiveRecord::Migration[5.0]
  def up
    rename_column Comment.table_name, :type, :user_type
    
    add_index Comment.table_name, :user_type
    
    Comment.where(user_type: 'MobileComment').update_all user_type: 'MobileUser' 
    Comment.where(user_type: 'SlackComment').update_all user_type: 'SlackUser' 
  end

  def down
    Comment.where(user_type: 'MobileUser').update_all user_type: 'MobileComment' 
    Comment.where(user_type: 'SlackUser').update_all user_type: 'SlackComment' 
    
    rename_column Comment.table_name, :user_type, :type
    
    drop_index Comment.table_name, :user_type
  end
end
