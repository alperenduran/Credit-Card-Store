//
//  Validator.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 14.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation
import UIKit

struct InputValidationError: Error {
    let error: Error
}

struct Validator: Error {
    static func validate<T>(errorMessage: String, test: @escaping (T) -> Bool) -> (_ input: T) throws -> T {
        return { input in
            if test(input) {
                return input
            }
            let error: ErrorObject = .init(message: errorMessage)
            throw InputValidationError(error: error)
        }
    }
}

struct ErrorObject: Equatable {
    let title: String
    let description: String
    let buttonTitle: String
}

extension ErrorObject {
    init(title: String = "Hata", message: String, buttonTitle: String = "Tamam") {
        self.title = title
        description = message
        self.buttonTitle = buttonTitle
    }
}

extension ErrorObject: Error{}

protocol ErrorHandler {
    func handle(error: Error) -> ErrorObject
}

extension ErrorHandler {
    func handle(error: Error) -> ErrorObject {
        return ErrorHandlerStruct.handle(error: error)
    }
}

struct ErrorHandlerStruct {
    static func handle(error: Error) -> ErrorObject {
        switch error {
        case let error as ErrorObject:
            return error
        default:
            return .init(message: "Bir hata oluştu.")
        }
    }
}

struct Validations {
    static func email(text: String) -> Bool {
        let formattedEmail = text.removeWhitespaces()
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: formattedEmail)
    }
    
    static func phone(text: String) -> Bool {
        let formattedNumber = text
            .removeWhitespaces()
            .onlyDigits
        
        var requiredCount = 10
        if formattedNumber.first == "0" {
            requiredCount = 11
        } else if formattedNumber.first == "9" {
            requiredCount = 12
        }
        return length(count: requiredCount)(formattedNumber)
    }
    
    static func length(count: Int) -> (_ text: String) -> Bool {
        return { text in
            return text.count == count
        }
    }
    
    static func onlyDigits(text: String) -> Bool {
        let noDigits = CharacterSet.decimalDigits.inverted
        return text.rangeOfCharacter(from: noDigits) == nil
    }
    
    static func minCharacter(count: Int) -> (_ text: String) -> Bool {
        return { text in
            return text.count >= count
        }
    }
    
    static func date(text: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let result = formatter.date(from: text)
        return result != nil
    }
    
    static func isNotEmpty(text: String) -> Bool {
        let trimmedText = text.trimmed()
        return !trimmedText.isEmpty
    }
}
