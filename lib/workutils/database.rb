require 'sqlite3'

class Database

  # setting up new database with given database name and columns:
  # fileskey (primary key), data (column for n0stromo), filename,
  # length (number of lines in file)
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def setup
    raise ArgumentError, "there is already database with this name" if correct_database_name?
    db = SQLite3::Database.new( "#{@name}.sqlite3" )
    db.execute( "create table files (fileskey INTEGER PRIMARY KEY, data TEXT, filename TEXT, length INTEGER)" )
    db.close
  end

  def correct_database_name?
    Dir['*.*'].include? ("#{@name}.sqlite3")
  end

end
