class TranslateContent < ActiveRecord::Migration
  def up
    # rename the existing columns
    rename_column :contents, :title, :old_title
    rename_column :contents, :caption, :old_caption
    rename_column :contents, :sub_caption, :old_sub_caption
    rename_column :contents, :content, :old_content

    # create translation table
    Content.create_translation_table! :title => :string, :caption => :string, :sub_caption => :string, :text => :text

    # move the data using the story_locale as the translation locale
    Story.transaction do
      Content.all.each do |content|
        locale = I18n.default_locale
        if content.section.present? and content.section.story.present?
          locale = content.section.story.story_locale 
          puts "- locale = #{locale}; content id = #{content.id}"
        else
          puts "---> could not find the story for this record #{content.id}, defaulting to locale #{locale}"
        end
        trans = content.translation_for(locale)
        trans.title = content.old_title
        trans.caption = content.old_caption
        trans.sub_caption = content.old_sub_caption
        trans.text = content.old_content
        trans.save
      end
    end
    #   Story.all.each do |story|
    #     puts "- id =#{story.id}; locale = #{story.story_locale}"
    #     Globalize.story_locale = story.story_locale
    #     story.sections.each do |section|
    #       if section.content?
    #         # somehow it is possible that there is more than one record per section so have to manually get the records
    #         Content.where(section_id: section.id).each do |content|
    #           puts "-- section id #{section.id}, content id = #{content.id}; current_locale = #{section.current_locale}"
    #           trans = content.translation_for(story.story_locale)
    #           trans.title = content.old_title
    #           trans.caption = content.old_caption
    #           trans.sub_caption = content.old_sub_caption
    #           trans.text = content.old_content
    #           trans.save
    #         end
    #       end
    #     end        
    #   end
    # end

  end

  def down
    # drop translation table
    Content.drop_translation_table!

    # rename exisitng columns
    rename_column :contents, :old_title, :title
    rename_column :contents, :old_caption, :caption
    rename_column :contents, :old_sub_caption, :sub_caption
    rename_column :contents, :old_content, :content

  end
end
