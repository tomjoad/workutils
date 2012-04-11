require 'sqlite3'
require 'rubygems'
require 'active_record'
require 'active_support'

module WorkUtils

  PROJECTS_PATH = "/home/lukasz/Projekty"

  module_function

  # connecting to database

  def connect(db="database.sqlite3")
     ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => db)
  end

  # database schema setter

  def generate_schema
    ActiveRecord::Schema.define do
      create_table :files do |t|
        t.column :name, :string
        t.column :number_of_lines, :integer
      end
    end
  end

  # seeding database with primary values

  def seed_database
    get_full_filenames.each do |file|
      Models::File.create(:name => file, :number_of_lines => count_number_of_lines(file))
    end
  end

  # counts number of lines in file indicated by file_path

  def count_number_of_lines(file_path)
    File.foreach(file_path).inject(0) { |count, line| count + 1 }
  end

  # returns array of strings which consists of full filenames
  # (eg. "/home/lukasz/Projekty/foo.rb") Main directory is "directory"

  def get_full_filenames(directory=PROJECTS_PATH)
    files = Dir.chdir(directory) do
      Dir['**/*.rb'].collect { |item| item = File.expand_path(item, directory) }
    end
  end

  # def working_directory_filenames(path)
  #   files = Dir.chdir(path) do
  #     Dir['**/*.rb']
  #   end
  # end

  # def full_path_filenames(filenames, projects_path)
  #   filenames.collect do |item|
  #     item = File.expand_path(item, projects_path)
  #   end
  # end

  # cleaning database by removing deleted files from it

  def clean_up_database
    new_files = get_full_filenames
    Models::File.all.each do |file|
      file.destroy unless new_files.include? file.name
    end
  end

  # comapring old files (stored in db) with current ones
  # printing results to output
  def compare
    clean_up_database
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

    return deleted_lines added_lines
  end

end
