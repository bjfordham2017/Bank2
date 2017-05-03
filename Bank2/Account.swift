//
//  Account.swift
//  Bank2
//
//  Created by Brent Fordham on 5/2/17.
//  Copyright © 2017 Brent Fordham. All rights reserved.
//

import Foundation

class Account : Hashable {
    enum AccountType {
        case savings
        case checking
    }
    
    let type: AccountType
    let accountID: UUID
    var transactionHistory: [Transaction]
    
    var accountBalance: Double {
        return transactionHistory.reduce(0) {(accumulator, element) in
            return accumulator + element.changeToBalance}
    }
    
    
    var hashValue: Int {
        return accountID.hashValue &+ type.hashValue
    }
    
    public static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.accountBalance == rhs.accountBalance && lhs.type == rhs.type && lhs.accountID == rhs.accountID
    }
    
    
    init(type: AccountType) {
        self.type = type
        self.accountID = UUID()
        self.transactionHistory = []
    }
    
    internal init(type: AccountType, accountID: UUID, transactionHistory: [Transaction]) {
        self.type = type
        self.accountID = accountID
        self.transactionHistory = transactionHistory
    }
    
    func checkBalance() -> Double {
        return self.accountBalance
    }
    
    func recordTransaction(_ input: Transaction) {
        transactionHistory.append(input)
    }
    
    func getHistory() -> [Transaction] {
        return transactionHistory
    }
    
    var jsonObject: [String: Any] {
        return [Account.typeKey: type,
                Account.accountIDKey: accountID,
                Account.transactionHistoryKey: transactionHistory]
    }
    
    convenience init?(jsonObject: [String: Any]) {
        guard let type = jsonObject[Account.typeKey] as? AccountType,
        let accountID = jsonObject[Account.accountIDKey] as? UUID,
        let transactionHistory = jsonObject[Account.transactionHistoryKey] as? [Transaction]
            else {
                return nil
        }
        self.init(type: type, accountID: accountID, transactionHistory: transactionHistory)
    }
    
    public static let typeKey: String = "Type"
    public static let accountIDKey: String = "accountID"
    public static let transactionHistoryKey: String = "transactionHistory"
    
}

class CheckingAccount: Account {
    
    init() {
        super.init(type: .checking)
    }
    
    internal override init(type: AccountType, accountID: UUID, transactionHistory: [Transaction]) {
        super.init (type: type, accountID: accountID, transactionHistory: transactionHistory)
    }
    
    convenience init?(jsonObject: [String: Any]) {
        guard let type = jsonObject[Account.typeKey] as? AccountType,
            let accountID = jsonObject[Account.accountIDKey] as? UUID,
            let transactionHistory = jsonObject[Account.transactionHistoryKey] as? [Transaction]
            else {
                return nil
        }
        
        self.init(type: type, accountID: accountID, transactionHistory: transactionHistory)
    }
    
}

class SavingsAccount: Account {
    
    init() {
        super.init(type: .savings)
    }
}
