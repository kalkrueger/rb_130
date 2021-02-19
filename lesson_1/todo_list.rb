class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end


class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo_item)
    if todo_item.instance_of?(Todo)
      @todos << todo_item
    else
      raise TypeError, "Can only add Todo Objects"
    end
  end
  alias_method :<<, :add

  def size
    @todos.size
  end

  def first
    @todos[0].title
  end

  def last
    @todos[-1].title
  end

  def to_a
    @todos.clone
  end

  def done?
    @todos.all?{ |item| item.done? }
  end

  def item_at(item_index)
    @todos.fetch(item_index)
  end

  def mark_done_at(item_index)
    item_at(item_index).done!
  end

  def mark_undone_at(item_index)
    item_at(item_index).undone!
  end

  def done!
    @todos.each{ |item| item.done! }
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def remove_item_at(item_index)
    @todos.delete(item_at(item_index))
  end

  def to_s
    text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end

  def each
    @todos.each{ |item| yield(item) }
    self
  end

  def select
    results = TodoList.new("Selected")
    @todos.each { |item| results.add(item) if yield(item)}
    results
  end

  def find_by_title(title)
    select{ |item| item.title == title }.first
  end

  def all_done
    select{ |item| item.done?}
  end

  def all_not_done
    select{ |item| !item.done?}
  end

  def mark_done(title)
    find_by_title(title) && find_by_title(title).done!
  end

  def mark_all_done
    each{ |item| item.done!}
  end

  def mark_all_undone
    each{ |item| item.undone!}
  end

end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")

list = TodoList.new("Today's Todos")
list.add(todo1)
list.add(todo2)
list.add(todo3)

results = list.select { |todo| todo.done? }    # you need to implement this method

p list.find_by_title("Buy milk")
list.mark_all_done
p list.all_done
list.mark_all_undone
p list.all_not_done
