class UnitsController < ApplicationController
  before_action :parse_code,   only: %i[download]
  before_action :set_unit,     only: %i[download show]
  before_action :check_status, only: %i[download]

  def index
    @unit = Unit.new
  end

  def create
    result = Units::Upload.call(file_params: unit_params)

    redirect_to result[:unit], flash: { key: result[:key] }
  end

  def download
    send_data(
      Units::Download.call(unit: @unit, key: @key),
      filename: @unit.title
    )
  end

  private

  def set_unit
    @unit ||= Unit.find_by(id: params[:unit_id] || params[:id])
  end

  def unit_params
    params.require(:unit).permit(:file)
  end

  def parse_code
    unit_id, @key = Base64.decode64(params[:file_key]).split('_')
    params.merge!(unit_id: unit_id)
  end

  def check_status
    render :not_ready and return if @unit.blank? || @unit.status == :pending
  end
end
