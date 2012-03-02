require 'ostruct'
config = OpenStruct.new(YAML.load_file("#{Rails.root}/config/config.yml"))
::AppConfig = OpenStruct.new(config.send(Rails.env))
::AppConfig.twilio_conf = YAML.load_file(::AppConfig.twilio_conf_file)
