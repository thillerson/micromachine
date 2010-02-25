require 'test/unit'
require 'rubygems'
require 'contest'

require File.dirname(__FILE__) + "/../lib/micromachine"

class HashThatDisallowsAnAnyKeyTest < Test::Unit::TestCase

  context "a hash that doesn't allow the :any key" do
    
    setup do
      @restrictive_hash = HashThatDisallowsAnAnyKey.new
    end

    should "allow other keys" do
      assert "ok", @restrictive_hash[:other_key] = "ok"
    end
    should "not allow the :any key" do
      assert_raise HashThatDisallowsAnAnyKey::RestrictedKey do
        @restrictive_hash[:any] = "Please Press the Any Key"
      end 
    end
  end
end