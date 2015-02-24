class TransactionMailer < ActionMailer::Base

	default from: "services@estuk.com"

	def order_completed(owner_email, buyer_email, book)
		
		@book = book
		@owner_email = owner_email
		@buyer_email = buyer_email

		mail(to: buyer_email,
			 subject: "Order Completed",
		)
	end

end



