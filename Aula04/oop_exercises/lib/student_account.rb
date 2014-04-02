require_relative 'checking_account'

class StudentAccount < CheckingAccount
	def initialize
		super
		@monthly_fee = 0
	end
  def withdraw(amount)
    if(@balance>=amount)
      @balance -= amount
      log_transaction('Withdrawal', amount)
	end
  end
  def transfer (account,amount)
		if(@balance>=@@tax+amount)
			self.withdraw(amount)
      		account.deposit(amount)
      		self.withdraw(@@tax)
      	end
	end
  end

