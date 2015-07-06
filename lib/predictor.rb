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
    @full_name = full_name
    if patterns[:first_name_dot_last_name] === company_email
      [first_name_dot_last_name]
    elsif patterns[:first_name_dot_last_initial] === company_email
      [first_name_dot_last_initial]
    elsif patterns[:first_initial_dot_last_name] === company_email
      [first_initial_dot_last_name]
    elsif patterns[:first_initial_dot_last_initial] === company_email
      [first_initial_dot_last_initial]
    else
      [first_name_dot_last_name, first_name_dot_last_initial, first_initial_dot_last_name, first_initial_dot_last_initial]
    end
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

  def company_email
    emails_hash.values.find{|email| email.include?(domain)}
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

end