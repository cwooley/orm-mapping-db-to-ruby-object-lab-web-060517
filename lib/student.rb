require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def initialize(name = nil, grade = nil, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new(row[1], row[2], row[0])
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    get_all = "SELECT * FROM students"
    master_arr = DB[:conn].execute(get_all)

    master_arr.map do |student_arr|
      Student.new_from_db(student_arr)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students WHERE grade = "9"
    SQL
    students_arr =  DB[:conn].execute(sql)
    students_arr
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE grade < 12
    SQL
    students_arr =  DB[:conn].execute(sql)
    students_arr
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT #{x}
    SQL
    students_arr =  DB[:conn].execute(sql)
    students_arr
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL
    students_arr =  DB[:conn].execute(sql).flatten
    self.new_from_db(students_arr)
  end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = #{x}
    SQL
    students_arr =  DB[:conn].execute(sql)
    students_arr
  end

end
