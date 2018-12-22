class Dog
  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name: nil, breed: nil , id: nil)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
  sql = <<-SQL
    DROP TABLE dogs
  SQL
  DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs(name, breed) VALUES (?, ?)
    SQL

    result = DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    return self
  end

  def self.create(dog_hash)
    new_dog = Dog.new
    dog_hash.each do |key, value|
      new_dog.send("#{key}=", value)
    end
    new_dog.save
  end

  def self.new_from_db(dog_hash)
    Dog.new(dog_hash[0], dog_hash[1], dog_hash[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM dogs WHERE name = ?
    SQL

    DB[:conn].execute(sql, name).map do |row|
       self.new_from_db(row)
     end.frst
  end


end
