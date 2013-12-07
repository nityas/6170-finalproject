class User < ActiveRecord::Base
	#Regex source: Michael Hartl Tutorial
    validates :email, presence: true, uniqueness: true
    has_many :offerings
    has_secure_password

    validates :password, length: {minimum: 6}, :allow_blank => true
    validates :phoneNumber,length: {is: 10}, uniqueness: true, presence: true, if: lambda{ |record| record.provider.present? }
	validates :provider, presence: true, if: lambda{ |record| record.phoneNumber.present? }
	before_create :create_remember_token

    def send_password_reset
    	generate_token(:password_reset_token)
    	self.password_reset_sent_at = Time.zone.now
    	save!(validate: false)
    	UserMailer.password_reset(self).deliver
    end

    def generate_token(column)
	  begin
	    self[column] = SecureRandom.urlsafe_base64
	  end while User.exists?(column => self[column])
	end

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
		elsif providerName.eql? "Verizon"
			return "@vtext.com"
		else
			return nil
		end
	end


	def can_subscribe?()
    	return self.phoneNumber.nil? || self.provider.nil?
	end

	private
		def create_remember_token
	      self.remember_token = User.encrypt(User.new_remember_token)
	    end
end
