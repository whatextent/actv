require 'actv/identity_map'
# require 'twitter/rate_limit'

module ACTV
  class Base
    attr_reader :attrs
    alias body attrs
    alias to_hash attrs

    @@identity_map = IdentityMap.new

    # Define methods that retrieve the value from an initialized instance variable Hash, using the attribute as a key
    #
    # @overload self.    attr_reader(attr)
    #   @param attr [Symbol]
    # @overload self.    attr_reader(attrs)
    #   @param attrs [Array<Symbol>]
    def self.attr_reader(*attrs)
      attrs.each do |attribute|
        class_eval do
          define_method attribute do
            @attrs[attribute.to_sym]
          end
        end
      end
    end

    def self.fetch(attrs)
      @@identity_map[self] ||= {}
      @@identity_map[self][Marshal.dump(attrs)]
    end

    def self.from_response(response={})
      self.fetch(response[:body]) || self.new(response[:body])
    end

    def self.fetch_or_new(attrs={})
      self.fetch(attrs) || self.new(attrs)
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [ACTV::Base]
    def initialize(attrs={})
      self.update(attrs)
      @@identity_map[self.class] ||= {}
      @@identity_map[self.class][Marshal.dump(attrs)] = self
    end

    # Fetches an attribute of an object using hash notation
    #
    # @param method [String, Symbol] Message to send to the object
    def [](method)
      self.send(method.to_sym)
    rescue NoMethodError
      nil
    end

    # Update the attributes of an object
    #
    # @param attrs [Hash]
    # @return [ACTV::Base]
    def update(attrs)
      @attrs ||= {}
      @attrs.update(attrs)
      self
    end

    def method_missing(meth, *args, &block)
      if @attrs && @attrs.has_key?(meth)
        @attrs[meth]
      else
        super
      end
    end

    def respond_to?(meth, *args)
      if @attrs && @attrs.has_key?(meth)
        true
      else
        super
      end
    end

  protected

    # @param attr [Symbol]
    # @param other [ACTV::Base]
    # @return [Boolean]
    def attr_equal(attr, other)
      self.class == other.class && !other.send(attr).nil? && self.send(attr) == other.send(attr)
    end

    # @param other [ACTV::Base]
    # @return [Boolean]
    def attrs_equal(other)
      self.class == other.class && !other.attrs.empty? && self.attrs == other.attrs
    end

  end
end