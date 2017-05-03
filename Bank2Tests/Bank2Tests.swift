//
//  Bank2Tests.swift
//  Bank2Tests
//
//  Created by Brent Fordham on 5/2/17.
//  Copyright © 2017 Brent Fordham. All rights reserved.
//

import XCTest
@testable import Bank2

class Bank2Tests: XCTestCase {
    
    func testPersonInit() {
        let newPerson: Person = Person(firstName: "Jim", lastName: "Holden")
        let result = newPerson.fullName
        let expected = "Jim Holden"
        XCTAssertEqual(result, expected)
    }
    
    func testCustomerInit1() {
        let newCustomer = Customer(firstName: "Naomi", lastName: "Nagata", emailAddress: "nnagata@roci.com")
        let result = newCustomer.fullName
        let expected = "Naomi Nagata"
        XCTAssertEqual(result, expected)
    }
    
    func testCheckBalanceMethod() {
        let newAccount = SavingsAccount()
        let result = newAccount.checkBalance()
        let expected: Double = 0.0
        XCTAssertEqual(result, expected)
    }
    
    func testBankNewEmployeeMethod() {
        let newBank = Bank(address: "123 Fourth Avenue, New York, NY")
        let newEmployee = Person(firstName: "Bobbie", lastName: "Draper")
        newBank.addEmployee(newEmployee)
        
        let result = newBank.employees
        let expected = [newEmployee]
        XCTAssertEqual(result, expected)
    }
    
    func testAddCustomer() {
        let newCustomer = Customer(firstName: "Naomi", lastName: "Nagata", emailAddress: "nnagata@roci.com")
        let newBank = Bank(address: "123 Fourth Avenue, New York, NY")
        let newAccount = SavingsAccount()
        
        newBank.addCustomer(newCustomer, firstAccount: newAccount)
        let result = newBank.accountsDirectory
        let expected: [Customer: Set<Account>] = [newCustomer: [newAccount]]
        XCTAssertEqual(result, expected)
    }
    
    func testFindCustomerAccounts() {
        let newCustomer = Customer(firstName: "Naomi", lastName: "Nagata", emailAddress: "nnagata@roci.com")
        let newBank = Bank(address: "123 Fourth Avenue, New York, NY")
        let newAccount = SavingsAccount()
        
        newBank.addCustomer(newCustomer, firstAccount: newAccount)
        let result = newBank.findCustomerAccounts(newCustomer)
        let expected: Set<Account> = [newAccount]
        XCTAssertEqual(result, expected)
    }
    
    func testRecordTransaction() {
        let newAccount = SavingsAccount()
        let newTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newAccount.recordTransaction(newTransaction)
        
        let result = newAccount.getHistory()
        let expected: [Transaction] = [newTransaction]
        XCTAssertEqual(result, expected)
    }
    
    func testFindCustomerBalance() {
        let newCustomer = Customer(firstName: "Naomi", lastName: "Nagata", emailAddress: "nnagata@roci.com")
        let newBank = Bank(address: "123 Fourth Avenue, New York, NY")
        let newAccount = SavingsAccount()
        let newTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newAccount.recordTransaction(newTransaction)
        
        newBank.addCustomer(newCustomer, firstAccount: newAccount)
        let result = newBank.findCustomerBalance(newCustomer)
        let expected: Double = 500
        XCTAssertEqual(result, expected)
    }
    
    func testNewAccountForCustomer() {
        let newCustomer = Customer(firstName: "Naomi", lastName: "Nagata", emailAddress: "nnagata@roci.com")
        let newBank = Bank(address: "123 Fourth Avenue, New York, NY")
        let newAccount = SavingsAccount()
        let newTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newAccount.recordTransaction(newTransaction)
        
        newBank.addCustomer(newCustomer, firstAccount: newAccount)
        
        let newNewAccount = CheckingAccount()
        let secondTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newNewAccount.recordTransaction(secondTransaction)
        
        newBank.newAccountForCustomer(newCustomer, newAccount: newNewAccount)
        
        let result = newBank.findCustomerAccounts(newCustomer)
        let expected: Set<Account> = [newAccount, newNewAccount]
        XCTAssertEqual(result, expected)
    }
    func testBankTotalFunds() {
        let newCustomer = Customer(firstName: "Naomi", lastName: "Nagata", emailAddress: "nnagata@roci.com")
        let newBank = Bank(address: "123 Fourth Avenue, New York, NY")
        let newAccount = SavingsAccount()
        let newTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newAccount.recordTransaction(newTransaction)
        
        newBank.addCustomer(newCustomer, firstAccount: newAccount)
        
        let newNewAccount = CheckingAccount()
        let secondTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newNewAccount.recordTransaction(secondTransaction)
        
        newBank.newAccountForCustomer(newCustomer, newAccount: newNewAccount)
        
        let newNewCustomer = Customer(firstName: "Jim", lastName: "Holden", emailAddress: "jholden@roci.com")
        let newCustomerNewAccount = SavingsAccount()
        let thirdDeposit = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newCustomerNewAccount.recordTransaction(thirdDeposit)
        
        newBank.addCustomer(newNewCustomer, firstAccount: newCustomerNewAccount)
        
        let result = newBank.bankTotalFunds()
        let expected: Double = 1500
        XCTAssertEqual(result, expected)
    }
    
    func testWithdraw() {
        let newCustomer = Customer(firstName: "Naomi", lastName: "Nagata", emailAddress: "nnagata@roci.com")
        let newBank = Bank(address: "123 Fourth Avenue, New York, NY")
        let newAccount = SavingsAccount()
        let newTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newAccount.recordTransaction(newTransaction)
        
        newBank.addCustomer(newCustomer, firstAccount: newAccount)
        
        let newNewAccount = CheckingAccount()
        let secondTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newNewAccount.recordTransaction(secondTransaction)
        
        newBank.newAccountForCustomer(newCustomer, newAccount: newNewAccount)
        
        let newNewCustomer = Customer(firstName: "Jim", lastName: "Holden", emailAddress: "jholden@roci.com")
        let newCustomerNewAccount = SavingsAccount()
        let thirdDeposit = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newCustomerNewAccount.recordTransaction(thirdDeposit)
        
        newBank.addCustomer(newNewCustomer, firstAccount: newCustomerNewAccount)
        let firstWithdrawal = Transaction(amount: 100, type: .debit, vendor: "Tycho Station", date: Date())
        
        newBank.recordTransactionForCustomer(customer: newCustomer, accountID: newAccount.accountID, transaction: firstWithdrawal)
        
        let result = newBank.findCustomerBalance(newCustomer)
        let expected: Double = 900
        XCTAssertEqual(result, expected)
    }
    
    func testDeposit() {
        let newCustomer = Customer(firstName: "Naomi", lastName: "Nagata", emailAddress: "nnagata@roci.com")
        let newBank = Bank(address: "123 Fourth Avenue, New York, NY")
        let newAccount = SavingsAccount()
        let newTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newAccount.recordTransaction(newTransaction)
        
        newBank.addCustomer(newCustomer, firstAccount: newAccount)
        
        let newNewAccount = CheckingAccount()
        let secondTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newNewAccount.recordTransaction(secondTransaction)
        
        newBank.newAccountForCustomer(newCustomer, newAccount: newNewAccount)
        
        let newNewCustomer = Customer(firstName: "Jim", lastName: "Holden", emailAddress: "jholden@roci.com")
        let newCustomerNewAccount = SavingsAccount()
        let thirdDeposit = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newCustomerNewAccount.recordTransaction(thirdDeposit)
        
        newBank.addCustomer(newNewCustomer, firstAccount: newCustomerNewAccount)
        let firstWithdrawal = Transaction(amount: 100, type: .debit, vendor: "Tycho Station", date: Date())
        
        newBank.recordTransactionForCustomer(customer: newCustomer, accountID: newAccount.accountID, transaction: firstWithdrawal)
        
        let anotherDeposit = Transaction(amount: 200, type: .credit, vendor: "Tycho Station", date: Date())
        newBank.recordTransactionForCustomer(customer: newCustomer, accountID: newAccount.accountID, transaction: anotherDeposit)
        
        let result = newBank.findCustomerBalance(newCustomer)
        let expected: Double = 1100
        XCTAssertEqual(result, expected)
    }
    
    func testGetHistoryForCustomer() {
        let newCustomer = Customer(firstName: "Naomi", lastName: "Nagata", emailAddress: "nnagata@roci.com")
        let newBank = Bank(address: "123 Fourth Avenue, New York, NY")
        let newAccount = SavingsAccount()
        let newTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newAccount.recordTransaction(newTransaction)
        
        newBank.addCustomer(newCustomer, firstAccount: newAccount)
        
        let newNewAccount = CheckingAccount()
        let secondTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newNewAccount.recordTransaction(secondTransaction)
        
        newBank.newAccountForCustomer(newCustomer, newAccount: newNewAccount)
        
        let newNewCustomer = Customer(firstName: "Jim", lastName: "Holden", emailAddress: "jholden@roci.com")
        let newCustomerNewAccount = SavingsAccount()
        let thirdTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        newCustomerNewAccount.recordTransaction(thirdTransaction)
        
        newBank.addCustomer(newNewCustomer, firstAccount: newCustomerNewAccount)
        let fourthTransaction = Transaction(amount: 100, type: .debit, vendor: "Tycho Station", date: Date())
        
        newBank.recordTransactionForCustomer(customer: newCustomer, accountID: newAccount.accountID, transaction: fourthTransaction)
        
        let fifthTransaction = Transaction(amount: 200, type: .credit, vendor: "Tycho Station", date: Date())
        newBank.recordTransactionForCustomer(customer: newCustomer, accountID: newAccount.accountID, transaction: fifthTransaction)
        
        let result = newBank.getHistoryForCustomer(customer: newCustomer, accountID: newAccount.accountID)!
        let expected: [Transaction] = [newTransaction, fourthTransaction, fifthTransaction]
        XCTAssertEqual(result, expected)
    }
    
    func testCustomerSerialization() {
        let expectedFirstName = "Jim"
        let expectedLastName = "Holden"
        let expectedEmailAddress = "jholden@roci.com"
        
        let newCustomer = Customer(firstName: expectedFirstName, lastName: expectedLastName, emailAddress: expectedEmailAddress)
        
        let result = newCustomer.jsonObject
        
        if let resultFirstName = result[Customer.firstNameKey] as? String,
            let resultLastName = result[Customer.lastNameKey] as? String,
            let resultEmailAddress = result[Customer.emailAddressKey] as? String {
            XCTAssertEqual(expectedFirstName, resultFirstName)
            XCTAssertEqual(expectedLastName, resultLastName)
            XCTAssertEqual(expectedEmailAddress, resultEmailAddress)
        } else {
            XCTFail("Failed to extract values for JSON keys.")
        }
    }
    
    func testTransactionSerialization() {
        let newTransaction = Transaction(amount: 500, type: .credit, vendor: "Tycho Station", date: Date())
        let result = Transaction(jsonObject: newTransaction.jsonObject)
        XCTAssertEqual(newTransaction, result)
    }
    
    func testAccountSerialization() {
        let newAccount = CheckingAccount()
        let result = CheckingAccount(jsonObject: newAccount.jsonObject)
        XCTAssertEqual(newAccount, result)
    }
    
    func testBankSerialization() {
        let newBank = Bank(address: "1 Big Bank Road, Bankersville")
        let result = Bank(jsonObject: newBank.jsonObject)
        XCTAssertEqual(newBank, result)
    }
    
}
