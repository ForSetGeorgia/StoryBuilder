REQUIRED_CONFIGS = [
  :author,
  :tag,
  :related_story,
  :categorization_type,
  :categorization_placement ]
def config_loader

  required_configs = REQUIRED_CONFIGS.clone

  $_config = {}
  $_flag = {}

  YAML.load_file("#{Rails.root}/config/config.yml").each {|cnf|
    key = cnf[:key].to_sym
    value = cnf[:value]

    required_configs.delete(key)

    $_config[key] = { value: value, description: cnf[:description], input_type: cnf[:input_type], possible_values: cnf[:possible_values] }
    case key
      when :author
        $_flag[:is_author_simple] = value == 'simple'
        $_flag[:is_author_complex] = value == 'complex'
      when :tag
        $_flag[:has_tag] = value == 'true'
      when :related_story
        $_flag[:has_related_story] = value != 'none'
        $_flag[:is_related_story_theme] = value == 'theme'
        $_flag[:is_related_story_category] = value == 'category'
        $_flag[:is_related_story_language] = value == 'language'
        $_flag[:is_related_story_tag] = value == 'tag'
      when :categorization_type
        $_flag[:is_categorization_type_category] = value == 'category'
        $_flag[:is_categorization_type_theme] = value == 'theme'
      when :categorization_placement
        $_flag[:has_categorization_placement] = value != 'none'
        $_flag[:has_categorization_placement_nav] = value == 'nav' || value == 'both'
        $_flag[:has_categorization_placement_filter] = value == 'filter' || value == 'both'
      when :story_creation_permission
        $_flag[:is_story_creation_permission_all] = value == 'all'
        $_flag[:is_story_creation_permission_coordinator] = value == 'coordinator'
      when :disclaimer
        $_flag[:has_disclaimer] = value == 'true'
      else
    end
  }


  if required_configs.present?
    puts "Missing required application configuration key: #{required_configs.join(', ')}"
    exit
  end
end

config_loader
