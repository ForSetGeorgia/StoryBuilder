class Config < ActiveRecord::Base
  REQUIRED_CONFIGS = [
    :author,
    :category_publishable ]

  validate :value_match_to_possible_values
  def value_match_to_possible_values
    errors.add(:value, "is unknown, should be one of these [#{values.join(', ')}]") unless values.index(value).present?
  end

  def self.required_keys
    REQUIRED_CONFIGS.clone
  end

  def self.value_by(key)
    pair = where(key: key).first
    pair.present? ? pair.value : nil
  end

  def self.keys
    pluck(:key)
  end

  def values
    JSON.parse(self.possible_values).map(&:to_s)
  end
end

