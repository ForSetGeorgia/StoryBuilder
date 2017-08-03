class Config < ActiveRecord::Base
  REQUIRED_CONFIGS = [
    :author,
    :category_publishable # ,
    # :dummy
  ]
  # def self.init
  #   required_configs = REQUIRED_CONFIGS.clone
  #   @config = {}
  #   Config.all.each{|e|
  #     key = e.key.to_sym
  #     required_configs.delete(key)
  #     @config[key] = e.value
  #     instance_variable_set("@config_#{e.key}".to_sym, e.value)
  #     @config["_#{e.key}".to_sym] = { value: e.value, input_type: e.input_type, possible_values: JSON.parse(e.possible_values) }
  #     Config.process_config(key, e.value)
  #   }

  #   required_configs
  # end

  def self.required_keys
    REQUIRED_CONFIGS.clone
  end

  # def self.process_config(key, value)
  #   case key
  #     when :author
  #       @config_is_author_simple = value == 'simple'
  #       @config_is_author_complex = !@config_is_author_simple
  #       Rails.logger.debug("--------------------------------------#{@config_is_author_complex}------#{key} #{value}")
  #     when :category_publishable
  #     else
  #   end
  # end

  def self.value_by(key)
    pair = where(key: key).first
    pair.present? ? pair.value : nil
  end

  def self.keys
    pluck(:key)
  end
end

