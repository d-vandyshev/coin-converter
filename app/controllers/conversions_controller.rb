class ConversionsController < ApplicationController
  def index
    render json: conversions(param_limit)
  end

  def new
    conv_params = params_conversion
    from = Cryptocurrency.find_by(name: conv_params[:from_currency])
    to = Cryptocurrency.find_by(name: conv_params[:to_currency])
    Conversion.create(
      from_currency_id: from.id,
      to_currency_id: to.id,
      amount: conv_params[:amount]
    )
    render json: { cost: conv_params[:amount] * from.price_usd / to.price_usd }
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
      { from_currency: c.from_currency.name,
        to_currency: c.to_currency.name,
        amount: c.amount,
        created_at: c.created_at }
    end
  end
end
