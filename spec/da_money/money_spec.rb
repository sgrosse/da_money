require 'spec_helper'

class DaMoney::Money
  def self.conversion_rates
    YAML.load_file('spec/fixtures/conversion_rates.yml')
  end
end

describe DaMoney::Money do

  before do
    @fifty_eur = DaMoney::Money.new(50, 'EUR')
    @twenty_dollars = DaMoney::Money.new(20, 'USD')
  end

  describe ".amount" do
    it 'should return an amount' do
      expect(@fifty_eur.amount).to eq 50.0
    end
  end

  describe ".currency" do
    it 'should have a currency' do
      expect(@fifty_eur.currency).to eq 'EUR'
    end
  end

  describe ".inspect" do
    it 'should return a currency string' do
      expect(@fifty_eur.inspect).to eq '50.00 EUR'
    end
  end

  describe ".convert_to" do
    it 'should convert 20.00 USD to 17.81 EUR' do
      expect(DaMoney::Money.new(20, 'USD').convert_to('EUR')).to eq DaMoney::Money.new(17.81, 'EUR')
    end

    it 'should convert 50.00 EUR to 56.21 USD' do
      expect(fifty_eur_in_usd = @fifty_eur.convert_to('USD')).to eq DaMoney::Money.new(56.21, 'USD')
    end
  end

  describe "+" do
    it 'should add DaMoney::Money' do
      expect(@fifty_eur + @fifty_eur).to eq DaMoney::Money.new(100.00, 'EUR')
    end

    it 'should add DaMoney::Money with different currencies' do
      expect(@fifty_eur + @twenty_dollars).to eq DaMoney::Money.new(67.81, 'EUR')
    end
  end

  describe "-" do
    it 'should substract DaMoney::Money' do
      expect(@fifty_eur - @fifty_eur).to eq DaMoney::Money.new(0.00, 'EUR')
    end 

    it 'should substract DaMoney::Money with different currencies' do
      expect(@fifty_eur - @twenty_dollars).to eq DaMoney::Money.new(32.19, 'EUR')
    end
  end

  describe "/" do
    it 'should divide DaMoney::Money by Numerical' do
      expect(@fifty_eur / 2).to eq DaMoney::Money.new(25.00, 'EUR')
    end 
  end

  describe "*" do
    it 'should multiply DaMoney::Money by Numerical' do
      expect(@twenty_dollars * 3).to eq DaMoney::Money.new(60.00, 'USD')
    end 
  end

  describe "==" do
    before do
      @fifty_eur_in_usd = @fifty_eur.convert_to('USD')
    end

    it 'compare DaMoney::Money objects with the same currency' do
      expect(@twenty_dollars == DaMoney::Money.new(20, 'USD')).to eq true
    end

    it 'compare DaMoney::Money objects with the same currency' do
      expect(@twenty_dollars == DaMoney::Money.new(30, 'USD')).to eq false
    end

    it 'compare DaMoney::Money objects with different currencies' do
      expect(@fifty_eur_in_usd == @fifty_eur).to eq true
    end

    it 'compare DaMoney::Money objects with different currencies' do
      expect(@twenty_dollars > DaMoney::Money.new(5, 'USD')).to eq true
    end

    it 'compare DaMoney::Money objects with different currencies' do
      expect(@twenty_dollars < @fifty_eur).to eq true
    end
  end

end
