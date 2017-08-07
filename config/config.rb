REQUIRED_CONFIGS = [
  :author,
  :category_publishable ]
def config_loader

  required_configs = REQUIRED_CONFIGS.clone

  $_config = {}
  $_flag = {}

  YAML.load_file("#{Rails.root}/config/config.yml").each {|cnf|
    key = cnf[:key].to_sym
    value = cnf[:value]

    required_configs.delete(key)

    $_config[key] = { value: value, input_type: cnf[:input_type], possible_values: cnf[:possible_values] }
    puts "--------------------------test"
    case key
      when :author
        $_flag[:is_author_simple] = value == 'simple'
        $_flag[:is_author_complex] = !$_flag[:is_author_simple]
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
