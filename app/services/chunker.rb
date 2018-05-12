class Chunker < Callable
  def initialize(params = {})
    @chunked_content = params[:chunked_content]
    @single_handler  = params[:single_handler]
    @chunks_handler  = params[:chunks_handler]
    @final_handler   = params[:final_handler]
    @object          = params[:object]
    @parallel        = params[:parallel]
    @count           = 0
  end

  def call
    return Thread.new { work } if parallel

    work
  end

  private

  attr_accessor :chunked_content,
                :single_handler,
                :chunks_handler,
                :final_handler,
                :object,
                :parallel,
                :count

  def work
    chunked_content.each_with_index { |chunk, index| run_thread(chunk, index) }
  end

  def run_thread(chunk, index)
    Thread.new do
      object.send(chunks_handler, result: object.send(single_handler, chunk), order: index)

      semaphore.synchronize do
        @count += 1
        object.send(final_handler) if @count == chunked_content.length
      end
    end
  end

  def semaphore
    @semaphore ||= Mutex.new
  end
end