class Chunker < Callable
  def initialize(params = {})
    @chunked_content = params[:chunked_content]
    @single_handler  = params[:single_handler]
    @chunks_handler  = params[:chunks_handler]
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

    result.each { |chunk| object.send(chunks_handler, chunk) }

    object.send(final_handler)
  end

  private

  attr_accessor :chunked_content,
                :single_handler,
                :chunks_handler,
                :final_handler,
                :object,
                :parallel
end