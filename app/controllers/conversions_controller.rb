class ConversionsController < ApplicationController
  def index
    render json: conversions(param_limit)
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

  def param_limit
    params[:limit] ||= Rails.configuration.x.conversions.default_limit
    params[:limit].to_i
  end

  def conversions(limit)
    Conversion.list_last(limit).map do |c|
      {from_currency: c.from_currency.name,
       to_currency: c.to_currency.name,
       amount: c.amount,
       created_at: c.created_at}
    end
  end
end
