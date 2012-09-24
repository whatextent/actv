require 'actv/address'
require 'actv/phone_number'

module ACTV
  class User < ACTV::Identity

    attr_reader :first_name, :last_name, :middle_name, :gender, 
      :display_name, :date_of_birth, :email

    alias dob date_of_birth
    
    def address
      @address ||= ACTV::Address.fetch_or_new(@attrs[:address]) unless @attrs[:address].nil?
    end

    def phone_number
      @phone_number ||= ACTV::PhoneNumber.fetch_or_new(@attrs[:phone_number]) unless @attrs[:phone_number].nil?
    end
    
  end
end