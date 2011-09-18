# encoding: utf-8
require 'spec_helper'

describe KingDta::Account do

  before :each do
    @ba = test_kto2 # BankAccount mocked as open struct
  end

  it "should initialize a new account" do
    lambda{ 
      KingDta::Account.new(:bank_account_number => @ba.bank_account_number,
                           :bank_number => @ba.bank_number,
                           :owner_name => @ba.owner_name)
    }.should_not raise_error
  end

  it "should initialize a new dtazv account" do
    lambda{ 
      KingDta::Account.new(sender_opts)
    }.should_not raise_error
  end

  it "should fail if bank account number is invalid" do
    # lambda{ KingDta::Account.new(0, @ba.bank_number, @ba.owner_name) }.should raise_error(ArgumentError)
    lambda{ 
      KingDta::Account.new(:bank_account_number => 123456789011123456789011123456789011,
                           :bank_number => @ba.bank_number,
                           :owner_name => @ba.owner_name)

    }.should raise_error(ArgumentError, 'Bank account number too long, max 35 allowed')
  end

  it "should fail if bank number is invalid" do
    lambda{ 
      KingDta::Account.new( :bank_account_number => @ba.bank_account_number,
                            :bank_number => 0,
                            :owner_name => @ba.owner_name)
    }.should raise_error(ArgumentError)

    lambda{ 
      KingDta::Account.new( :bank_account_number => @ba.bank_account_number,
                            :bank_number => 123456789101112,
                            :owner_name => @ba.owner_name)
    }.should raise_error(ArgumentError, 'Bank number too long, max 11 allowed')
  end

  it "should fail if owner number is too long" do
    lambda{ 
      KingDta::Account.new( :bank_account_number => @ba.bank_account_number,
                            :bank_number => @ba.bank_number,
                            :owner_name => @ba.owner_name,
                            :owner_number => 12345678901)
    }.should raise_error(ArgumentError, 'Owner number too long, max 10 allowed')
  end

  it "should fail if street and/or Zip Code is too long" do    
    opts = sender_opts.merge( :bank_street => "Lorem ipsum dolor sit amet, consectetur")
    lambda{
      KingDta::Account.new(opts)
    }.should raise_error(ArgumentError, 'Bank street too long, max 35 allowed')
  end

  it "should fail if city is too long" do
    opts = sender_opts.merge( :bank_city => "Lorem ipsum dolor sit amet, consecte")
    lambda{ 
      KingDta::Account.new opts
    }.should raise_error(ArgumentError, 'Bank city too long, max 35 allowed')
  end

  it "should fail if bank name is too long" do
    opts = sender_opts.merge( :bank_name => "Lorem ipsum dolor sit amet, consecte")
    lambda{
      KingDta::Account.new opts
    }.should raise_error(ArgumentError, 'Bank name too long, max 35 allowed')
  end

  it "should fail if client street is too long" do
    opts = sender_opts.merge( :owner_street => "Lorem ipsum dolor sit amet, consecte")
    lambda{
      KingDta::Account.new opts
    }.should raise_error(ArgumentError, 'Owner street too long, max 35 allowed')
  end

  it "should fail if city is too long" do
    opts = sender_opts.merge( :owner_city => "Lorem ipsum dolor sit amet, consecte")
    lambda{
      KingDta::Account.new opts
    }.should raise_error(ArgumentError, 'Owner city too long, max 35 allowed')
  end

  it "should return account street and zip" do
    acnt = KingDta::Account.new( sender_opts )
    acnt.bank_zip_city.should == "51063 BANK KOELN"
  end

  it "should return sender street and zip" do
    acnt = KingDta::Account.new( sender_opts )
    acnt.owner_zip_city.should == "51063 MEINE KOELN"
  end

  it "should set owner country code from iban" do
    opts = receiver_opts
    opts[:owner_country_code] = nil
    acnt = KingDta::Account.new( opts )
    acnt.owner_country_code.should == "PL"
  end
end