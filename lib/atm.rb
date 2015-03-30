class CardRetained < Exception; end
class InsufficientFunds < Exception; end

class ATM
  attr_accessor :balance
  def initialize(balance)
    @balance = balance
  end
  def withdraw(card, amount)
    raise CardRetained unless card.valid
    raise InsufficientFunds if card.account.balance < amount

    card.account.balance -= amount
    @balance -= amount

    amount
  end
end

class Account
  attr_accessor :balance
  def initialize(balance)
    @balance = balance
  end
end

class Card
  attr_accessor :account, :valid
  def initialize(account, valid)
    @account = account
    @valid = valid
  end
end
