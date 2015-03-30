require 'atm'

Before do
  @atm = ATM.new(0)
  @account = Account.new(0)
  @card = Card.new(@account, false)
  @thrown_exception = nil
  @dispensed_amount = 0
end

Given(/^the account balance is (\d+)$/) do |balance|
  @account.balance = balance.to_i
end

Given(/^the card is valid$/) do
  @card.valid = true
end

Given(/^the machine contains enough money$/) do
  @atm.balance = 100000
end

When(/^the account holder requests (\d+)$/) do |amount|
  begin
    @dispensed_amount = @atm.withdraw(@card, amount.to_i)
  rescue CardRetained => e
    @thrown_exception = e
  rescue InsufficientFunds => e
    @thrown_exception = e
  end
end

Then(/^the ATM should dispense (\d+)$/) do |amount|
  @dispensed_amount.should == amount.to_i
end

Then(/^the account balance should be (\d+)$/) do |balance|
  @account.balance.should == balance.to_i
end

Then(/^the card should be returned$/) do
  @thrown_exception.class.should_not == CardRetained
end

Then(/^the ATM should not dispense any money$/) do
  @dispensed_amount.should == 0
end

Then(/^the ATM should say there are insufficient funds$/) do
  @thrown_exception.class.should == InsufficientFunds
end

Given(/^the card is disabled$/) do
  @card.valid = false
end

Then(/^the ATM should retain the card$/) do
  @thrown_exception.class.should == CardRetained
end

