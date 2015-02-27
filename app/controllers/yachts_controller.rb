class YachtsController < ApplicationController

  before_filter :collection,     only: :index
  before_filter :fetch_contacts, only: :show
  before_filter :resource,       only: :show


  def index; end

  def show
    respond_to do |format|
      format.html { render :show, layout: false }
      format.pdf
    end
  end

  protected

    def collection
      @yachts ||= Yacht.includes(:cover).for_sale

      rates = CurrencyMarket.rates

      @yachts.sort! do |a, b|
        if a.currency == 'EUR'
          price_a = a.price
        else
          price_a = a.price * rates['EUR']['value']
          price_a = price_a / rates[a.currency]['value']
        end

        if b.currency == 'EUR'
          price_b = b.price
        else
          price_b = b.price * rates['EUR']['value']
          price_b = price_b / rates[b.currency]['value']
        end

        price_b <=> price_a
      end

      @yachts = YachtDecorator.decorate_collection(@yachts)
    end

    def resource
      @yacht ||= Yacht.includes(:cover, :photos, :schemes)
                      .find(params[:id])
                      .decorate
    end

    def fetch_contacts
      @contacts = Contact.first.decorate
    end

end
