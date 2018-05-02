class UnitsController < ApplicationController
  def index
    @unit = Unit.new
  end

  def create
    @unit = Unit.new(modified_params)

    saved = @unit.save

    redirect_to units_path, notice: saved ? 'Successfully' : 'Failure'
  end

  private

  def unit_params
    params.require(:unit).permit(:file)
  end

  def modified_params
    unit_params.tap do |uparams|
      uparams.merge!(content: content)
      uparams.merge!(encoded: encoded)
    end
  end

  def content
    @content ||= params.dig(:unit, :file)&.read
  end

  def encoded
    Huffman::Encode.call(content: content).to_s
  end
end
