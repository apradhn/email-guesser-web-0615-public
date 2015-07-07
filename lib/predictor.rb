require 'json'
require 'pry'

class Predictor
  attr_reader :file, :emails_hash, :domain, :patterns, :full_name


  def initialize(path)
    @file = File.read(path)
    @emails_hash = JSON.parse(file)
    @patterns = {
      first_name_dot_last_name: /\A[a-z]{2,}\.[a-z]{2,}@[a-z]+\.[a-z]{3}/,
      first_name_dot_last_initial: /\A[a-z]{2,}\.[a-z]{1}@[a-z]+\.[a-z]{3}/,
      first_initial_dot_last_name: /\A[a-z]{1}\.[a-z]{2,}@[a-z]+\.[a-z]{3}/,
      first_initial_dot_last_initial: /\A[a-z]{1}\.[a-z]{1}@[a-z]+\.[a-z]{3}/
    }    
  end

  def guess(full_name, domain)
    @domain = domain
    email = Email.new(full_name, domain)
    case company_email
    when patterns[:first_name_dot_last_name]
      [email.first_name_dot_last_name]
    when patterns[:first_name_dot_last_initial] 
      [email.first_name_dot_last_initial]
    when patterns[:first_initial_dot_last_name]
      [email.first_initial_dot_last_name]
    when patterns[:first_initial_dot_last_initial]
      [email.first_initial_dot_last_initial]
    else
      email.all
    end
  end  

  def company_email
    emails_hash.values.find{|email| email.include?(domain)}
  end

end

class Email
  attr_reader :full_name, :domain

  def initialize(full_name, domain)
    @full_name = full_name
    @domain = domain
  end

  def first_name
    full_name.split(" ").first.downcase
  end

  def last_name
    full_name.split(" ").last.downcase
  end

  def first_initial
    first_name[0]
  end

  def last_initial
    last_name[0]
  end  

  def first_name_dot_last_name
    first_name + "." + last_name + "@" + domain
  end

  def first_name_dot_last_initial
    first_name + "." + last_initial + "@" + domain
  end

  def first_initial_dot_last_name
    first_initial + "." + last_name + "@" + domain
  end

  def first_initial_dot_last_initial
    first_initial + "." + last_initial + "@" + domain
  end

  def all
    [first_name_dot_last_name, first_name_dot_last_initial, first_initial_dot_last_name, first_initial_dot_last_initial]
  end  
end