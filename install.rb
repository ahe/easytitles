FileUtils.cp_r( 
  Dir[File.join(File.dirname(__FILE__), 'config')], 
  File.join(RAILS_ROOT),
  :verbose => true
)