require 'helper'
require_relative 'dummy_output'

class DummyChain
  def next
  end
end

class PullPoolBufferTest < Test::Unit::TestCase
  CONFIG = %[
    buffer_type pullpool
    buffer_path /tmp/pullpooltest
    flush_interval 1s
  ]

  def create_driver1(conf=CONFIG, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::DummyBuffered1Output, tag).configure(conf)
  end

  def create_driver2(conf=CONFIG, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::DummyBuffered2Output, tag).configure(conf)
  end

  def test_configure
    d = create_driver1
    assert d.instance # successfully configured

    d = create_driver2
    assert d.instance # successfully configured
  end

  def test_emit1
    d = create_driver1
    buffer = d.instance.instance_eval{ @buffer }
    assert buffer
    d.instance.start

    chain = DummyChain.new
    tag = d.instance.instance_eval{ @tag }
    time = Time.now.to_i

    buffer.emit(tag, d.instance.format(tag, time, {"a" => 1}), chain)
    buffer.emit(tag, d.instance.format(tag, time, {"a" => 2}), chain)
    buffer.emit(tag, d.instance.format(tag, time, {"a" => 3}), chain)
    buffer.emit(tag, d.instance.format(tag, time, {"a" => 4}), chain)

    d.instance.instance_eval{ @next_flush_time = Time.now.to_i - 30 }
    d.instance.try_flush

    assert_equal 4, d.instance.written.size
  end


  def test_emit2
    d = create_driver2
    buffer = d.instance.instance_eval{ @buffer }
    assert buffer
    d.instance.start

    chain = DummyChain.new
    tag = d.instance.instance_eval{ @tag }
    time = Time.now.to_i

    buffer.emit(tag, d.instance.format(tag, time, {"a" => 1}), chain)
    buffer.emit(tag, d.instance.format(tag, time, {"a" => 2}), chain)
    buffer.emit(tag, d.instance.format(tag, time, {"a" => 3}), chain)
    buffer.emit(tag, d.instance.format(tag, time, {"a" => 4}), chain)

    d.instance.instance_eval{ @next_flush_time = Time.now.to_i - 30 }
    d.instance.try_flush

    assert_equal 0, d.instance.written.size

    d.instance.execute_pull
    assert_equal 4, d.instance.written.size

    buffer.emit(tag, d.instance.format(tag, time, {"a" => 5}), chain)
    buffer.emit(tag, d.instance.format(tag, time, {"a" => 6}), chain)
    buffer.emit(tag, d.instance.format(tag, time, {"a" => 7}), chain)

    d.instance.instance_eval{ @next_flush_time = Time.now.to_i - 30 }
    d.instance.try_flush

    assert_equal 4, d.instance.written.size

    d.instance.execute_pull
    assert_equal 7, d.instance.written.size

    buffer.emit(tag, d.instance.format(tag, time, {"a" => 8}), chain)
    buffer.emit(tag, d.instance.format(tag, time, {"a" => 9}), chain)

    d.instance.instance_eval{ @next_flush_time = Time.now.to_i - 30 }
    d.instance.try_flush

    buffer.emit(tag, d.instance.format(tag, time, {"a" => 10}), chain)

    d.instance.instance_eval{ @next_flush_time = Time.now.to_i - 30 }
    d.instance.try_flush

    assert_equal 7, d.instance.written.size

    d.instance.execute_pull
    assert_equal 10, d.instance.written.size

  end
end
