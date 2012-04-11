require 'sqlite3'
require 'rubygems'
require 'active_record'
require 'active_support'

module WorkUtils

  PROJECTS_PATH = "/home/lukasz/Projekty"

  module_function

  def connect(db="database.sqlite3")
     ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => db)
  end

  def generate_schema
    ActiveRecord::Schema.define do
      create_table :files do |t|
        t.column :name, :string
        t.column :number_of_lines, :integer
      end
    end
  end

  def compare
  end

  def seed_database
    full_filenames = expand_filenames(working_directory_filenames(PROJECTS_PATH), (PROJECT_PATH))
    full_filenames.each do |file|
      Models::File.create(:name => file, :number_of_lines => count_number_of_lines(file))
    end
  end

  def count_number_of_lines(path)
    File.foreach(path).inject(0) { |count, line| count + 1 }
  end

  def working_directory_filenames(path)
    files = Dir.chdir(path) do
      Dir['**/*.rb']
    end
  end

  def expand_filenames(filenames, projects_path)
    filenames.collect do |item|
      item = File.expand_path(item, projects_path)
    end
  end

end
