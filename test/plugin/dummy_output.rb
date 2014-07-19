require 'json'

module Fluent
  class DummyBuffered1Output < BufferedOutput
    Fluent::Plugin.register_output('pullpool_test1', self)

    attr_reader :written

    def start
      super
      @written = []
    end

    def format(tag, time, record)
      [tag, time, record.merge({"format_time" => Time.now.to_f})].to_json + "\n"
    end

    def write(chunk)
      chunk_lines = chunk.read.split("\n").select{|line| not line.empty?}
      chunk_lines.each do |line|
        tag, time, record = JSON.parse(line)
        record.update({"write_time" => Time.now.to_f})
        @written.push record
      end
    end
  end

  class DummyBuffered2Output < BufferedOutput
    Fluent::Plugin.register_output('pullpool_test2', self)

    attr_reader :written

    def start
      super
      @written = []
    end

    def format(tag, time, record)
      [tag, time, record.merge({"format_time" => Time.now.to_f})].to_json + "\n"
    end

    def execute_pull
      @buffer.pull_chunks do |chunk|
        chunk_lines = chunk.read.split("\n").select{|line| not line.empty?}
        chunk_lines.each do |line|
          tag, time, record = JSON.parse(line)
          record.update({"write_time" => Time.now.to_f})
          @written.push record
        end
      end
    end
  end
end
