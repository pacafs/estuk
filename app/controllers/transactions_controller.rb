class TransactionsController < ApplicationController
	def create
		
		book = Book.find_by!(slug: params[:slug])
		sale = book.sales.create(
			amount: book.price,
			buyer_email: current_user.email,
			seller_email: book.user.email,
			stripe_token: params[:stripeToken])
		sale.process!
		
		if sale.finished?
			redirect_to pickup_url(guid: sale.guid), notice: "Transaction Successful"
			
			# Send Email to notify the user who place the order as well as the one you got paid!
			# current_user.email - Buyer Email
			# book.user.email - Book Owner Email

			TransactionMailer.order_completed(book.user.email, current_user.email, book).deliver
		else
			redirect_to book_path(book), notice: "Something went wrong"
		end
		
	end

	def pickup
		@sale = Sale.find_by!(guid: params[:guid])
		@book = @sale.book
	end
end