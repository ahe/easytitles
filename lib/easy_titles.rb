module EasyTitles
  
  # Load all titles YAML files in memory (files in RAILS_ROOT/config/titles)
  # Each file is accessible through the @@files hash : @@files[:en], @@files[:fr], ...
  # In development mode, this method is called everytime the easy_title helper is called
  def self.load_titles!
    @@files = {}
    base_path = "#{RAILS_ROOT}/config/titles/"
    base_dir  = Dir.new(base_path) rescue nil
    
    if !base_dir.nil?
      base_dir.each do |file|
        if file.ends_with?(".yml")
          @@files[file.split(".yml").first.to_sym] = YAML.load_file(base_path + file)
        end
      end
    end
  end
  
  # Get the title of the current controller/action
  def self.get_current_title(controller_name, action_name)
    
    titles = @@files[I18n.locale.to_sym] rescue nil
    titles = @@files[:all] if titles.nil?
    
    if titles.nil?
      'EasyTitles plugin : titles YAML file is missing'
    elsif !titles[controller_name].nil? && !titles[controller_name][action_name].nil?
      titles[controller_name][action_name]
    elsif !titles[controller_name].nil? && !titles[controller_name]['default'].nil?
      titles[controller_name]['default']
    elsif !titles['default'].nil?
      titles['default']
    else
      ''
    end
  end
  
end

module ActionView
  
  module Helpers
    
    # Use this helper method in the title tag of your layout
    def easy_title
      EasyTitles.load_titles! if RAILS_ENV == 'development'
      EasyTitles.get_current_title(controller.controller_name, controller.action_name)
    end
     
  end
end