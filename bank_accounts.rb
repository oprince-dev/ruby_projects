class BankAccount
  attr_reader :name
  attr_reader :timestamp

  def initialize(name, timestamp)
    @name = name
    @timestamp = timestamp
    @transactions = []
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

def user_add_account
  account_name = ask("Account Name:")
  timestamp = user_add_timestamp
  bank_account = BankAccount.new(account_name, timestamp)
  answer = ""
  initial_deposit = ask("How much would you like to add for your initial deposit?:")
  bank_account.add_transaction("Initial Deposit", initial_deposit.to_i, timestamp)
  bank_account.print_register
  user_deposit_withdraw(bank_account)
end

def user_deposit_withdraw(bank_account)
  while bank_account != ""
    answer = ask("Would you like to deposit or withdraw?:").downcase
    if answer == "deposit"
      timestamp = user_add_timestamp.to_s
      user_add_deposit(bank_account, timestamp)
    elsif answer == "withdraw"
      timestamp = user_add_timestamp.to_s
      user_add_withdraw(bank_account, timestamp)
    end
  end
end

def user_add_deposit(bank_account, timestamp)
  deposit_description = ask("Add a description to this deposit:")
  deposit_amount = ask("How much would you like to deposit?:").to_i
  bank_account.add_deposit(deposit_description, deposit_amount, timestamp)
  bank_account.print_register
end

def user_add_withdraw(bank_account, timestamp)
  withdraw_description = ask("Add a description to this withdraw:")
  withdraw_amount = ask("How much would you like to withdraw?:").to_i
  bank_account.add_withdraw(withdraw_description, withdraw_amount, timestamp)
  bank_account.print_register
end

def user_add_timestamp
  timestamp = Time.now.utc.to_s
  return timestamp
end

user_add_timestamp
user_add_account
