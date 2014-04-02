class SalaryAccount < CheckingAccount
	@@discount=0.5
	def initialize
		super
		@monthly_fee=MONTHLY_FEE*@@discount
	end

	def transfer(amount,account)
		
	end

end