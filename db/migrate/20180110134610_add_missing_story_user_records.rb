class AddMissingStoryUserRecords < ActiveRecord::Migration
  def up
    User.where('role >= ?', User::ROLES[:coordinator]).each do |user|
      puts user.email
      user.stories << Story.select(:id).where('id not in (select story_id from story_users where user_id = ?)', user.id)
    end
  end

  def down
    puts "do nothing"
  end
end
