class User < ActiveRecord::Base
	#Regex source: Michael Hartl Tutorial
    validates :email, presence: true, uniqueness: true
    has_many :offerings
    has_secure_password
    validates :password, length: {minimum: 6}
    validates :phoneNumber, length: {is: 10}
    #validates_presence_of :provider :if => :phoneNumber?
    before_create :create_remember_token
	
	def User.new_remember_token
	  SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
	  Digest::SHA1.hexdigest(token.to_s)
	end

	def provider_to_email(providerName)		 
		if providerName.eql? "T-Mobile"
			return "@tmomail.net"
		elsif providerName.eql? "AT&T"
			return "@txt.att.net"
		else providerName.eql? "Verizon"
			return "@vtext.com"
		end
	end
	private
		def create_remember_token
	      self.remember_token = User.encrypt(User.new_remember_token)
	    end
end
