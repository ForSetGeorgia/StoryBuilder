class Admin::ConfigsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do |controller_instance|
    controller_instance.send(:valid_role?, User::ROLES[:site_admin])
  end
  before_filter do @model = Config; end
  before_filter :asset_filter

  # GET /pages
  def index
    @items = @model.all

    @css.push("dataTables/bootstrap/3/jquery.dataTables.bootstrap.css")
    @js.push("dataTables/jquery.dataTables.js", "dataTables/bootstrap/3/jquery.dataTables.bootstrap.js", "search.js")

    respond_to do |format|
      format.html
    end
  end

  # GET /pages/1/edit
  def edit
    @item = @model.find(params[:id])
  end

  # PUT /pages/1
  def update
    @item = @model.find(params[:id])


    respond_to do |format|
      if @item.update_attributes(params[:config])
        require 'yaml' # Built in, no gem required
        File.write("#{Rails.root}/config/config.yml", Config.all.map {|m| { key: m.key, value: m.value, description: m.description, input_type: m.input_type, possible_values: m.possible_values }}.to_yaml)
        config_loader
        format.html { redirect_to admin_configs_path, flash: {success:  t('app.msgs.success_updated', :obj => t('activerecord.models.config'))} }
      else
        format.html { render action: "edit" }
      end
    end
  end

protected
  def asset_filter
    @css.push("navbar.css", "configs.css")
  end
  # def _params
  #   params.require(:config).permit(:id, :key, :value)
  # end
end
