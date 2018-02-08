class StoryObserver < ActiveRecord::Observer

  def after_save(story)
    # story.send_notification = story.published_changed? && story.published == true
#    story.send_staff_pick_notification = story.published && story.staff_pick_changed? && story.staff_pick == true

    # need this to work during migration from first production release to new look
    begin
      # story.send_comment_notification = story.published && story.comments_count_changed?
    rescue
    end
    return true
  end

  # send notification
  def after_commit(story)
    # if story.send_notification
    #   NotificationTrigger.add_published_story(story.id)
    # end

    # if story.send_staff_pick_notification
    #   NotificationTrigger.add_staff_pick_selection(story.id)
    # end

    if story.send_comment_notification
      NotificationTrigger.add_story_comment(story.id)
    end
    return true
  end
end
