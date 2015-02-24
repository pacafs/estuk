class Book < ActiveRecord::Base
	extend FriendlyId
	friendly_id :name, use: :slugged

	belongs_to :user
	has_many :sales
	has_attached_file :image
	has_attached_file :resource

	validates_attachment_content_type :image, 
	content_type:  /^image\/(png|gif|jpeg)/,
	message: "Only images allowed"

	validates_attachment_content_type :resource,
	content_type: ['application/pdf'],
	message: "Only pdfs allowed"

	validates :image, attachment_presence: true
	validates :resource, attachment_presence: true

	validates_numericality_of :price,
	greater_than: 49, message: "must be at least 50 cents"

	# Search

	def self.search(search, author, min_price, max_price)

		books = all

		books = books.where('name LIKE ?', "%#{search}%") if search.present?
		books = books.where('author LIKE ?', "%#{author}%") if author.present?
		books = books.where("price >= ?", min_price) if min_price.present?
		books = books.where("price <= ?", max_price) if max_price.present?
	
		return books

	end

	scope :available, -> { where(availability: true) }
	
end