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

  def seed_database
    full_filenames = full_path_filenames(working_directory_filenames(PROJECTS_PATH), PROJECTS_PATH)
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

  def full_path_filenames(filenames, projects_path)
    filenames.collect do |item|
      item = File.expand_path(item, projects_path)
    end
  end

  # cleaning database by removing deleted files from it

  def clean_up_database
    new_files = full_path_filenames(working_directory_filenames(PROJECTS_PATH), PROJECTS_PATH)
    Models::File.all.each do |file|
      file.destroy unless new_files.include? file.name
    end
  end

  def compare
    clean_up_database
    # new_files = full_path_filenames(working_directory_filenames(PROJECTS_PATH), PROJECTS_PATH)
    added_lines = 0
    deleted_lines = 0
    Models::File.all.each do |file|
      temp = count_number_of_lines(file.name) - file.number_of_lines
      if temp < 0
        deleted_lines += temp.abs
      elsif temp > 0
        added_lines += temp
      end
      file.number_of_lines = count_number_of_lines(file.name)
      file.save
    end

    p deleted_lines
    p added_lines
    # new_files.each do |file|
    #   temp = count_number_of_lines(file) - Models::File.find_by_name(file).number_of_lines
    #   if temp < 0
    #     added_lines += temp
    #     Models::File.find_by_name(file).
    #   elsif temp > 0
    #     deleted_lines += temp.abs
    # end
    # add_new_files_to_database
  end

end
