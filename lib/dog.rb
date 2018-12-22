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


end
