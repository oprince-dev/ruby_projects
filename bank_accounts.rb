require 'json'

class BankAccount
  attr_reader :name
  attr_reader :timestamp

  def initialize(name, timestamp)
    @name = name
    @timestamp = timestamp
    @transactions = []
  end

  def save
    File.open("#{name}_account.json", "w+") do |f|
      f.write(JSON.pretty_generate(@transactions))
    end
  end

  def open
    f = File.read("#{name}_account.json")
    @transactions = JSON.parse(f,:symbolize_names => true)
  end

  def add_withdraw(description, amount, timestamp)
    add_transaction(description, -amount, timestamp)
  end

  def add_deposit(description, amount, timestamp)
    add_transaction(description, amount, timestamp)
  end

  def add_transaction(description, amount, timestamp)
    @transactions.push(description: description, amount: amount, timestamp: timestamp)
  end

  def balance
    balance = 0.0
    @transactions.each do |transaction|
      balance += transaction[:amount]
    end
    return balance
  end

  def to_s
    "Name: #{name}, Balance: #{sprintf("%0.2f", balance)}"
  end

  def print_register
    puts "\t" + " " * 100
    puts "\t" + "#{name}'s Imaginery Bank Account".ljust(60) + "Created on #{timestamp}".rjust(40)
    puts "\t" + "=" * 100

    puts "\t" + "Description".ljust(60) + "Amount".ljust(10) + "Time".rjust(30)
    puts "\t" + "~" * 100
    @transactions.each do |transaction|
      puts "\t" + transaction[:description].ljust(60) + sprintf("%0.2f", transaction[:amount]).ljust(10) + transaction[:timestamp].rjust(30)
      puts "\t" + " " * 100
    end
    puts "\t" + "~" * 100
    puts "\t" + "Balance: ".ljust(60) + "#{sprintf("%0.2f", balance)}".ljust(10)
    puts "\t" + "=" * 100
    puts "\t" + " " * 100
  end
end

def ask(q, kind="string")
    print q +  " "
    answer = gets.chomp
    answer = answer.to_i if kind == "number"
    return answer
end

def user_welcome
  answer = ask("Welcome.\n\nWould you like to:\n\t(1) Create an account\n\t(2) Login\n")
  if answer == "1"
    user_add_account
  elsif answer == "2"
    user_login
  else
    user_welcome
  end
end

def user_add_account
  account_name = ask("Account Name:")
  timestamp = user_add_timestamp

  bank_account = BankAccount.new(account_name, timestamp)
  initial_deposit = ask("How much would you like to add for your initial deposit?:")

  bank_account.add_transaction("Initial Deposit", initial_deposit.to_i, timestamp)
  bank_account.save
  bank_account.print_register

  user_deposit_withdraw(bank_account)
end

def user_login
  account_name = ask("Account Name: ")
  timestamp = user_add_timestamp

  bank_account = BankAccount.new(account_name, timestamp)
  bank_account.open
  bank_account.print_register

  user_deposit_withdraw(bank_account)
end

def user_deposit_withdraw(bank_account)
  while bank_account != ""
    answer = ask("Would you like to deposit or withdraw?:").downcase
    if answer == "deposit"
      user_add_deposit(bank_account)
    elsif answer == "withdraw"
      user_add_withdraw(bank_account)
    end
  end
end

def user_add_deposit(bank_account)
  deposit_description = ask("Add a description to this deposit:")
  deposit_amount = ask("How much would you like to deposit?:").to_i
  timestamp = user_add_timestamp.to_s

  bank_account.add_deposit(deposit_description, deposit_amount, timestamp)
  bank_account.save
  bank_account.print_register
end

def user_add_withdraw(bank_account)
  withdraw_description = ask("Add a description to this withdraw:")
  withdraw_amount = ask("How much would you like to withdraw?:").to_i
  timestamp = user_add_timestamp.to_s

  bank_account.add_withdraw(withdraw_description, withdraw_amount, timestamp)
  bank_account.save
  bank_account.print_register
end

def user_add_timestamp
  timestamp = Time.now.utc.to_s
  return timestamp
end


user_add_timestamp
user_welcome
