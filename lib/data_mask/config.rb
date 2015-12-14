require 'yaml'

module DataMask
  module Config
    def self.symbolize_keys(data)
      data.keys.each do |key|
        data[(key.to_sym rescue key) || key] = data.delete(key)
        symbolize_keys(data[key.to_sym]) if data[key.to_sym].is_a? Hash
      end
      data
    end

    def self.parse(name)
      symbolize_keys(YAML.load(File.open(name, 'rb').read))
    end
  end
end