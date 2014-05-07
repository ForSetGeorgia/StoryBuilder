class StorytellerController < ApplicationController
	layout false
  def index
  	@story = Story.is_published.fullsection(params[:id])  
  	if @story.present?
      respond_to do |format|     
        format.html 
      end
      # record the view count
      impressionist(@story)
    else
      redirect_to root_path, :notice => t('app.msgs.does_not_exist')
    end
  end
end
