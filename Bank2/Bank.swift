//
//  Bank.swift
//  Bank2
//
//  Created by Brent Fordham on 5/2/17.
//  Copyright © 2017 Brent Fordham. All rights reserved.
//

import Foundation

class Bank: Equatable {
    var address: String
    var employees: [Person]
    var accountsDirectory: [Customer : Set<Account>]
    
    init(address: String) {
        self.address = address
        self.employees = []
        self.accountsDirectory = [:]
    }
    
    internal init(address: String, employees: [Person], accountsDirectory: [Customer: Set<Account>]) {
        self.address = address
        self.employees = employees
        self.accountsDirectory = accountsDirectory
    }
    
    static func == (lhs: Bank, rhs: Bank) -> Bool {
        return lhs.address == rhs.address && lhs.accountsDirectory == rhs.accountsDirectory && lhs.employees == rhs.employees
    }
    
    func addEmployee(_ input: Person) {
        self.employees.append(input)
    }
    
    func addCustomer(_ newCustomer: Customer, firstAccount: Account) {
        var customerAccounts: Set<Account> = []
        customerAccounts.insert(firstAccount)
        accountsDirectory[newCustomer] = customerAccounts
    }
    
    func findCustomerAccounts(_ input: Customer) -> Set<Account>? {
        if let customerAccounts = accountsDirectory[input] {
            return customerAccounts
        } else {
            return nil
        }
    }
    
    func findCustomerBalance(_ input: Customer) -> Double? {
        var totalBalance: Double
        if let listOfAccounts = findCustomerAccounts(input) {
            totalBalance = listOfAccounts.reduce(0) {(accumulator, element) in
                return accumulator + element.accountBalance}
            return totalBalance
        } else {
            return nil
        }
    }
    func newAccountForCustomer(_ input: Customer, newAccount: Account) {
        if let _ = findCustomerAccounts(input) {
            accountsDirectory[input]?.insert(newAccount)
        }
    }
    func bankTotalFunds() -> Double {
        var totalFunds: Double = 0
        for (key, _) in accountsDirectory {
            if let customerBalance = findCustomerBalance(key) {
                totalFunds += customerBalance
            }
        }
        return totalFunds
    }
    func recordTransactionForCustomer(customer: Customer, accountID: UUID, transaction: Transaction) {
        if let customerAccounts = findCustomerAccounts(customer) {
            for account in customerAccounts {
                if account.accountID == accountID {
                    account.recordTransaction(transaction)
                }
            }
        }
    }
    func getHistoryForCustomer(customer: Customer, accountID: UUID) -> [Transaction]? {
        if let customerAccounts = findCustomerAccounts(customer) {
            for account in customerAccounts {
                if account.accountID == accountID {
                    return account.getHistory()
                }
            }
        }
        return nil
    }
    
    var jsonObject: [String: Any] {
        return [Bank.addressKey: address,
                Bank.employeesKey: employees,
                Bank.accountsDirectoryKey: accountsDirectory]
    }
    
    convenience init?(jsonObject: [String: Any]) {
        guard let address = jsonObject[Bank.addressKey] as? String,
        let employees = jsonObject[Bank.employeesKey] as? [Person],
        let accountsDirectory = jsonObject[Bank.accountsDirectoryKey] as? [Customer: Set<Account>]
            else {
                return nil
        }
        self.init(address: address, employees: employees, accountsDirectory: accountsDirectory)
    }
    
    public static let addressKey: String = "address"
    public static let employeesKey: String = "employees"
    public static let accountsDirectoryKey: String = "accountsDirectory"
}
