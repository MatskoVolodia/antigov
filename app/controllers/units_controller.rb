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
    unit_params.merge!(content: content)
  end

  def content
    params.dig(:unit, :file)&.read
  end
end
