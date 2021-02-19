require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'todolist'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    todo = @list.shift
    assert_equal(@todo1, todo )
    refute_includes(@list.to_a, todo)
  end

  def test_pop
    todo = @list.pop
    assert_equal(@todo3, todo)
    refute_includes(@list.to_a, todo)
  end

  def test_done?
    assert_equal(false, @list.done?)
  end

  def test_typeerror
    assert_raises(TypeError) {@list.add('orange')}
    assert_raises(TypeError) {@list.add(4)}
  end

  def test_add_alias
    new_todo = Todo.new("Walk Dog")
    @todos << new_todo
    @list.add(new_todo)
    assert_equal(@todos, @list.to_a )
  end

  def test_item_at
    assert_equal(@todos[1], @list.item_at(1))
    assert_raises(IndexError) {@list.item_at(50)}
  end

  def test_mark_done_at
    assert_equal(false, @todo1.done?)
    @list.mark_done_at(0)
    assert_equal(true, @todo1.done?)
    assert_raises(IndexError) {@list.mark_done_at(50)}
  end

  def test_mark_undone_at
    @list.mark_done_at(0)
    assert_equal(true, @todo1.done?)
    @list.mark_undone_at(0)
    assert_equal(false, @todo1.done?)
    assert_raises(IndexError) {@list.mark_undone_at(50)}
  end

  def test_done!
    @list.done!
    assert_equal(true, @list.done?)
  end

  def test_remove_item_at
    @list.remove_item_at(0)
    refute_includes(@list.to_a, @todo1)
    assert_raises(IndexError) {@list.remove_item_at(50)}
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_done
    @list.done!

    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_each
    test_arr = []
    @list.each{ |item| test_arr << item }
    assert_equal(@todos, test_arr)
  end

  def test_each_return
    test_arr = []
    assert_equal(@list, @list.each{ |item| test_arr << item })
  end

  def test_select
    @list.mark_done_at(1)
    assert_equal([@todo2], @list.select{ |item| item.done?}.to_a)
  end

  def test_mark_alls
    @list.mark_all_done
    assert_equal(true, @list.done?)
    @list.mark_all_undone
    assert_equal(@list.to_a, @list.all_not_done.to_a)
  end

  def test_all_lists
    @todo1.done!
    assert_equal([@todo1], @list.all_done.to_a)
    assert_equal([@todo2, @todo3], @list.all_not_done.to_a)
  end

  def test_mark_done
    @list.mark_done("Buy milk")
    assert_equal(true, @todo1.done?)
  end

end
