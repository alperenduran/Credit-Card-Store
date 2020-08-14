//
//  StringExtensions.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 14.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

// MARK: - Text Formatting
extension String {
    func removeWhitespaces() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    
    func removeNonNumerics() -> String {
        let nonNumericCharset = CharacterSet.decimalDigits.inverted
        let numericString = self.components(separatedBy: nonNumericCharset).joined(separator: "")
        return numericString
    }
    
    var isEmptyAfterRemovingSpaces: Bool {
        let formattedText = self.removeWhitespaces()
        return formattedText.isEmpty
    }
    
    /// Excludes non-digit characters from the string.
    var onlyDigits: String {
        let characterSet = CharacterSet.decimalDigits.inverted
        return components(separatedBy: characterSet)
            .joined()
    }
    
    func trimmed() -> String {
        let result = trimmingCharacters(in: .whitespacesAndNewlines)
        return result
    }
}

// MARK: - Validations
extension String {
    var isValidEmail: Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isPhoneNumberLenghtValid: Bool {
        let phoneFirstChar = String(prefix(1))
        let possibleLength = phoneFirstChar == "0" ? 16 : 15
        return count == possibleLength
    }
}

// MARK: - Pattern Number Format
extension String {
    func format(mask: FormatMaskType) -> String {
        let cleanPhoneNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let pattern = mask.pattern(for: self)
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for character in pattern where index < cleanPhoneNumber.endIndex {
            if character == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
}

// MARK: - Enums
enum FormatMaskType {
    case phoneNumber, amex, mastercard, visa
    
    func pattern(for text: String) -> String {
        switch self {
        case .phoneNumber:
            if text.first == "0" {
                return "#(###) ### ## ##"
            } else if text.first == "9" {
                return "## (###) ### ## ##"
            } else {
                return "(###) ### ## ##"
            }
        case .mastercard, .visa:
            return "#### #### #### ####"
        case .amex:
            return "#### ###### #####"
        }
    }
    
    var replacmentCharacter: Character {
        return "#"
    }
}

// MARK: - Convert
extension String {

    func convertToFloat() -> Float {
        return (replacingOccurrences(of: ",", with: ".") as NSString).floatValue
    }
        
    var toDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: NSTimeZone.local.secondsFromGMT())
        guard let date = formatter.date(from: self) else { return Date() }
        return date
    }
}

// MARK: - Locale Converter
extension String {
    var normalizeTurkishCharacters: String {
        var convertedWord = self
        let turkishChars = ["ı", "I", "İ", "ö", "Ö", "O", "ü", "Ü", "U", "ş", "S", "Ş", "ç", "Ç", "C", "ğ", "Ğ", "G"]
        let englishChars = ["i", "i", "i", "o", "o", "o", "u", "u", "u", "s", "s", "s", "c", "c", "c", "g", "g", "g"]
        
        zip(turkishChars, englishChars)
            .forEach { (turkishChar, englishChar) in
                convertedWord = convertedWord.replacingOccurrences(of: turkishChar, with: englishChar)
            }
        
        return convertedWord
    }
}

// MARK: - SHA256 Hash
extension String {
    func sha256() -> String{
        if let stringData = self.data(using: .utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

// MARK: - NSAttributedString + Extensions
extension String {
    func makeListPrice() -> NSAttributedString {
        NSAttributedString(
            string: self,
            attributes: [.strikethroughStyle: 1]
        )
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)

        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)

        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        return ceil(boundingBox.width)
    }
}

// MARK: - Text Matcher
extension String {
    func ranges(of searchString: String) -> [Range<String.Index>] {
        let _indices = indices(of: searchString)
        let count = searchString.count
        return _indices.map {
            index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0 + count)
        }
    }

    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(
                range.lowerBound,
                offsetBy: offset,
                limitedBy: endIndex) else { break }

            position = index(after: after)
        }
        return indices
    }
}
