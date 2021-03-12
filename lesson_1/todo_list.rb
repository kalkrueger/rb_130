# frozen_string_literal: true

# toplevel ToDo
class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description = '')
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

  def ==(other)
    title == other.title &&
      description == other.description &&
      done == other.done
  end
end

# toplevel List
class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(todo_item)
    raise TypeError, 'Can only add Todo Objects' unless
      todo_item.instance_of?(Todo)

    @todos << todo_item
  end
  alias << add

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
    @todos.all?(&:done?)
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
    @todos.each(&:done!)
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

  def each(&block)
    @todos.each(&block)
    self
  end

  def select
    results = TodoList.new('Selected')
    @todos.each { |item| results.add(item) if yield(item) }
    results
  end

  def find_by_title(title)
    select { |item| item.title == title }.first
  end

  def all_done
    select(&:done?)
  end

  def all_not_done
    select { |item| !item.done? }
  end

  def mark_done(title)
    find_by_title(title)&.done!
  end

  def mark_all_done
    each(&:done!)
  end

  def mark_all_undone
    each(&:undone!)
  end
end
