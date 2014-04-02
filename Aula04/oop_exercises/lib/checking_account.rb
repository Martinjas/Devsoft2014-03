require_relative 'bank_account'

class CheckingAccount < BankAccount
  @@tax = 8
  def deposit(amount)
    @balance += amount
    log_transaction('Deposit', amount)
  end

  def withdraw(amount)
    if @balance+CREDIT_LINE >=amount
      @balance -= amount
      log_transaction('Withdrawal', amount)
    end
  end

  def transfer(account, amount)
    if (@balance+CREDIT_LINE >=(@@tax + amount)&&@balance>500)
      self.withdraw(amount)
      account.deposit(amount)
      self.withdraw(@@tax)
    end

  end

end
