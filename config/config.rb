REQUIRED_CONFIGS = [
  :author,
  :tag,
  :category_publishable,
  :related_story ]
def config_loader

  required_configs = REQUIRED_CONFIGS.clone

  $_config = {}
  $_flag = {}

  YAML.load_file("#{Rails.root}/config/config.yml").each {|cnf|
    key = cnf[:key].to_sym
    value = cnf[:value]

    required_configs.delete(key)

    $_config[key] = { value: value, input_type: cnf[:input_type], possible_values: cnf[:possible_values] }
    case key
      when :author
        $_flag[:is_author_simple] = value == 'simple'
        $_flag[:is_author_complex] = !$_flag[:is_author_simple]
      when :tag
        $_flag[:has_tag] = value == 'true'
      when :related_story
        $_flag[:has_related_story] = value != 'empty'
        $_flag[:is_related_story_theme] = value == 'theme'
      when :category_publishable
      else
    end
  }


  if required_configs.present?
    puts "Missing required application configuration key: #{required_configs.join(', ')}"
    exit
  end
end

config_loader
