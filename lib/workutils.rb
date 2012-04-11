# loading to LOAD_PATH

$LOAD_PATH.unshift(File.dirname(__FILE__)) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) || $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

# required files

require "workutils/database.rb"
require "workutils/models.rb"
# execute

WorkUtils.connect()
# WorkUtils.generate_schema()
# WorkUtils.seed_database()
# WorkUtils::Models::File.create(:name => "lukasz")
# should be in smth like "install" rake file
# WorkUtils.generate_schema()
