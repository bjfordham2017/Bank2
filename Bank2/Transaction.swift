//
//  Transaction.swift
//  Bank2
//
//  Created by Brent Fordham on 5/2/17.
//  Copyright © 2017 Brent Fordham. All rights reserved.
//

import Foundation

struct Transaction: Equatable {
    enum TransactionType {
        case credit
        case debit
    }
    
    let amount: Double
    let type: TransactionType
    let vendor: String
    var userDescription: String?
    let dateCreated: Date
    var datePosted: Date?
    
    static func sanitize(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return calendar.date(from: components)!
    }
    
    
    
    var changeToBalance: Double {
        switch type {
        case .credit:
            return amount
        case .debit:
            return -amount
        }
    }
    
    public static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.amount == rhs.amount && lhs.type == rhs.type && lhs.vendor == rhs.vendor && lhs.dateCreated == rhs.dateCreated
    }

    init(amount: Double, type: TransactionType, vendor: String, date: Date) {
        self.amount = amount
        self.type = type
        self.vendor = vendor
        self.dateCreated = Transaction.sanitize(date: date)
        
        self.userDescription = nil
        self.datePosted = nil
    }
    
    internal init(amount: Double, type: TransactionType, vendor: String, userDescription: String?, dateCreated: Date, datePosted: Date?) {
        self.amount = amount
        self.type = type
        self.vendor = vendor
        self.userDescription = userDescription
        self.dateCreated = dateCreated
        self.datePosted = datePosted
    }
    
    mutating func postTransaction() {
        if datePosted == nil {
            datePosted = Date()
        }
    }
    
    mutating func addDescription(description: String) {
        userDescription = description
    }
    
    var jsonObject: [String: Any] {
        var output: [String: Any] = [
            Transaction.amountKey: amount,
            Transaction.typeKey: type,
            Transaction.vendorKey: vendor,
            Transaction.dateCreatedKey: dateCreated.timeIntervalSince1970,
            Transaction.datePostedKey: datePosted.map(Transaction.dateFormatter.string(from:)) as Any]
        
        if let description = userDescription {
            output[Transaction.userDescriptionKey] = description
        }
        
        return output
    }
    
    init?(jsonObject: [String: Any]) {
        guard let amount = jsonObject[Transaction.amountKey] as? Double,
        let vendor = jsonObject[Transaction.vendorKey] as? String,
        let type = jsonObject[Transaction.typeKey] as? TransactionType,
        let dateCreatedDouble = jsonObject[Transaction.dateCreatedKey] as? Double
            else {
                return nil
        }
        
        let dateCreated = Date(timeIntervalSince1970: dateCreatedDouble)
        
        let userDescription = jsonObject[Transaction.userDescriptionKey] as? String
        
        let datePostedString = jsonObject[Transaction.datePostedKey] as? String
        let datePosted = datePostedString.flatMap(Transaction.dateFormatter.date(from:))
        
        self.init(amount: amount, type: type, vendor: vendor, userDescription: userDescription, dateCreated: dateCreated, datePosted: datePosted)
        
    }
    
    public static let amountKey: String = "amount"
    public static let typeKey: String = "type"
    public static let vendorKey: String = "vendor"
    public static let userDescriptionKey: String = "userDescription"
    public static let dateCreatedKey: String = "dateCreated"
    public static let datePostedKey: String = "datePosted"
    
    internal static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ssZ"
        let timeZoneName = TimeZone.abbreviationDictionary["UTC"]!
        let timeZone = TimeZone(identifier: timeZoneName)
        formatter.timeZone = timeZone
        return formatter
    }()
}
