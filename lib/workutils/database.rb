require 'sqlite3'
require 'rubygems'
require 'active_record'
require 'active_support'

module WorkUtils

  module_function

  # def new_database(db="database.sqlite3")
  #    db = SQLite3::Database.new(db)
  #    db.close
  # end

  def connect(db="database.sqlite3")
     ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => db)
  end

  def generate_schema
    ActiveRecord::Schema.define do
      create_table :files do |t|
        t.column :name, :string
        t.column :line, :integer
      end
    end
  end
end

WorkUtils.connect()
WorkUtils.generate_schema()
