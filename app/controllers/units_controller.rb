class UnitsController < ApplicationController
  def index
    @unit = Unit.new
  end

  def create
    @unit = Unit.new(unit_params)

    saved = @unit.save

    redirect_to units_path, notice: saved ? 'Successfully' : 'Failure'
  end

  private

  def unit_params
    params.require(:unit).permit(:file)
  end
end
