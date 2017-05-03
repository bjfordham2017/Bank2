//
//  Person.swift
//  Bank2
//
//  Created by Brent Fordham on 5/2/17.
//  Copyright © 2017 Brent Fordham. All rights reserved.
//

import Foundation

class Person : Hashable {
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    
    var hashValue: Int {
        return firstName.hashValue &+ lastName.hashValue
    }
    
    public static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.fullName == rhs.fullName
    }
    
    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    convenience init?(jsonObject: [String: Any]) {
        guard let firstName = jsonObject[Person.firstNameKey] as? String,
            let lastName = jsonObject[Person.lastNameKey] as? String
            else {
                return nil
        }
        self.init(firstName: firstName, lastName: lastName)
    }
    
    public static var firstNameKey: String = "firstName"
    public static var lastNameKey: String = "lastName"
    
    var jsonObject: [String: Any] {
        return [Person.firstNameKey: firstName,
                Person.lastNameKey: lastName]
    }
    
}


class Customer: Person {
    var emailAddress: String
    init(firstName: String, lastName: String, emailAddress: String) {
        self.emailAddress = emailAddress
        super.init(firstName: firstName, lastName: lastName)
    }
    public static var emailAddressKey: String = "emailAddress"
    
    override var jsonObject: [String : Any] {
        return [Customer.firstNameKey: firstName,
                Customer.lastNameKey: lastName,
                Customer.emailAddressKey: emailAddress]
    }
    convenience init?(jsonObject: [String: Any]) {
        guard let firstName = jsonObject[Customer.firstNameKey] as? String,
            let lastName = jsonObject[Customer.lastNameKey] as? String,
            let emailAddress = jsonObject[Customer.emailAddressKey] as? String
            else {
                return nil
        }
        self.init(firstName: firstName, lastName: lastName, emailAddress: emailAddress)
    }
}
