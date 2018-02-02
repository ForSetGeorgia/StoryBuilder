class Template < ActiveRecord::Base
	has_many :stories
	attr_accessible :id,:name,:title,:description,:author,:params,:default,:public
	def self.select_list(self_template_id=-1)
		if self_template_id.blank?
			self_template_id = -1
		end
		where("public = true || id = #{self_template_id}").select("id, title, description").order("title asc")
	end
  def get_params()
    return self.params.nil? ? {} : JSON.parse(self.params)
  end

  def extra_js(export_mode=false)
    pars = get_params()
    return pars.kind_of?(Hash) && pars.key?('js') && pars['js'].kind_of?(Array) ? pars['js'].map{|m| "#{export_mode ? '' : "/assets/template/"}t#{self.id}_#{m}" } : []
  end
  def extra_css(export_mode=false)
    pars = get_params()
    return pars.kind_of?(Hash) && pars.key?('css') && pars['css'].kind_of?(Array) ? pars['css'].map{|m| "#{export_mode ? '' : "/assets/template/"}t#{self.id}_#{m}" } : []
  end
end
