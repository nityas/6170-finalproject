require 'test_helper'

class UserTest < ActiveSupport::TestCase

    #test that we convert the provider to the right provider getway
    def test_provider_to_email
        user1 = users(:user_one)
        user2 = users(:user_two)
        user3 = users(:user_three)
        user4 = users(:user_four)
        assert_equal "@tmomail.net", user1.provider_to_email(user1.provider)
        assert_equal "@txt.att.net", user2.provider_to_email(user2.provider)
        assert_equal "@vtext.com", user3.provider_to_email(user3.provider)
        assert_equal nil, user4.provider_to_email(user4.provider)
    end

    #test that given a phone number and a provider we can create a text mail
    def test_get_text_address
        user1 = users(:user_one)
        user2 = users(:user_two)
        user3 = users(:user_three)

        user1.provider = user1.provider_to_email(user1.provider)
        user2.provider = user2.provider_to_email(user2.provider)
        user3.provider = user3.provider_to_email(user3.provider)
        
        assert_equal "1231231234@tmomail.net", user1.get_text_address()
        assert_equal "8571231234@txt.att.net", user2.get_text_address()
        assert_equal "6171231234@vtext.com", user3.get_text_address()
    end  

    #test our ajax call to MIT people with a kerberos 
    def test_get_MIT_people_email
        user1 = users(:user_one)
        assert_equal true, user1.get_MIT_people_email().include?(user1.email)
    end

    #test if a user can subscribe or not
    def test_can_subscribe?
        user1 = users(:user_one)
        user2 = users(:user_two)
        user3 = users(:user_three)
        user4 = users(:user_four)
        assert_equal true, user1.can_subscribe?()
        assert_equal true, user2.can_subscribe?()
        assert_equal true, user3.can_subscribe?()
        assert_equal false, user4.can_subscribe?()
     end

end
