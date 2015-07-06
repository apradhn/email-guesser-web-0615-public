require 'json'
require 'pry'

class Predictor
  attr_reader :file, :emails_hash, :domain, :patterns, :first_name, :last_name


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
    parse_name(full_name)
    if patterns[:first_name_dot_last_name] === ex_email_from_domain
      [first_name_dot_last_name]
    elsif patterns[:first_name_dot_last_initial] === ex_email_from_domain
      [first_name_dot_last_initial]
    elsif patterns[:first_initial_dot_last_name] === ex_email_from_domain
      [first_initial_dot_last_name]
    elsif patterns[:first_initial_dot_last_initial] === ex_email_from_domain
      [first_initial_dot_last_initial]
    else
      [first_name_dot_last_name, first_name_dot_last_initial, first_initial_dot_last_name, first_initial_dot_last_initial]
    end
  end  

  def first_name_dot_last_name
    first_name + "." + last_name + "@" + domain
  end

  def first_name_dot_last_initial
    first_name + "." + last_name[0] + "@" + domain
  end

  def first_initial_dot_last_name
    first_name[0] + "." + last_name + "@" + domain
  end

  def first_initial_dot_last_initial
    first_name[0] + "." + last_name[0] + "@" + domain
  end

  def ex_email_from_domain
    emails_hash.values.find{|email| email.include?(domain)}
  end

  def parse_name(full_name)
    @first_name = full_name.split(" ").first.downcase
    @last_name = full_name.split(" ").last.downcase
  end

end