class Chunker < Callable
  def initialize(params = {})
    @chunked_content = params[:chunked_content]
    @single_handler  = params[:single_handler]
    @reducer         = params[:reducer]
    @final_handler   = params[:final_handler]
    @object          = params[:object]
    @parallel        = params[:parallel]
  end

  def call
    return Thread.new { work } if parallel

    work
  end

  def work
    threads = []
    result = []

    chunked_content.each_with_index do |chunk, index|
      threads << Thread.new do
        result << { result: object.send(single_handler, chunk), order: index }
      end
    end

    threads.each { |thr| thr.join }

    result.sort_by { |k| k[:order] }
      .map { |r| r[:result] }
      .inject { |total, current| object.send(reducer, total, current) }
      .tap { |joined| object.send(final_handler, joined) }
  end

  private

  attr_accessor :chunked_content, :single_handler, :reducer, :final_handler, :object, :parallel
end