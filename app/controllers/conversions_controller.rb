class ConversionsController < ApplicationController
  def index
    render json: Conversion.all.map { |c| {from_currency_id: c.from_currency_id, to_currency_id: c.to_currency_id, amount: c.amount} }
  end

  def new
    c_params = params_conversion
    from_cur = Cryptocurrency.find_by(name: c_params[:from_currency])
    to_cur = Cryptocurrency.find_by(name: c_params[:to_currency])
    answer = c_params[:amount] * from_cur.price_usd / to_cur.price_usd
    Conversion.create(from_currency_id: from_cur.id, to_currency_id: to_cur.id, amount: c_params[:amount])
    render json: {answer: answer}
  end

  private

  def params_conversion
    params.require(:conversion).permit(:from_currency, :to_currency, :amount)
  end
end
