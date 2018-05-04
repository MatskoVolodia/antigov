class UnitsController < ApplicationController
  before_action :set_unit, only: %i[download]

  def index
    @unit = Unit.new
  end

  def create
    Units::Upload.call(file_params: unit_params)

    redirect_to units_path
  end

  def download
    send_data(
      Units::Download.call(encoded: @unit.encoded),
      filename: @unit.title
    )
  end

  private

  def set_unit
    @unit ||= Unit.find_by(id: params[:unit_id])
  end

  def unit_params
    params.require(:unit).permit(:file)
  end
end
