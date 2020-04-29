//
//  String-Inspector.swift
//
//  Created by Claudio Madureira on 19/12/19.
//

import Foundation

public extension String {
    
    /// Check if the string contains only a brazilian physical person document number.
    ///
    /// `Throws` an Error in case the string doesn't match the required document format.
    func validateCPF() throws {
        let numbers = self.compactMap { Int(String($0)) }
        guard numbers.count == 11 else {
            throw NSError.init(domain: "ValidationDomain", code: -12345, userInfo: ["localizedDescription": "CPF incompleto."])
        }
        let invalidError = NSError.init(domain: "ValidationDomain", code: -12345, userInfo: ["localizedDescription": "CPF inválido."])
        guard Set(numbers).count != 1 else {
            throw invalidError
        }
        let soma1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        if !(dv1 == numbers[9] && dv2 == numbers[10]) {
            throw invalidError
        }
    }
    
    /// Check if the string matches an regular email format.
    ///
    /// `Throws` an Error in case the string doesn't match the required format.
    func validateEmail() throws {
        let regex = try NSRegularExpression(
            pattern: "^[A-Za-z0-9_\\-]+(?:[.][A-Za-z0-9_\\-]+)*@[A-Za-z0-9_]+(?:[-.][A-Za-z0-9_]+)*\\.[A-Za-z0-9_]+$",
            options: .caseInsensitive)
        if regex.firstMatch(
            in: self,
            options: NSRegularExpression.MatchingOptions(rawValue: 0),
            range: NSMakeRange(0, self.count)) == nil {
            throw NSError.init(domain: "ValidationDomain", code: -12345, userInfo: ["localizedDescription": "E-mail inválido."])
        }
    }
    
}

