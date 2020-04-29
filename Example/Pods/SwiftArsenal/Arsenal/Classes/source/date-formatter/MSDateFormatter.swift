//
//  MSDateFormatter.swift
//
//  Created by Claudio Madureira Silva Filho on 12/12/19.
//

import Foundation

/// Looking forward to solve a such anoying problem I had with Apple's DateFormatter, this formatter manages to identify when the iPhone is on AM hour mode and handles to convert a String to Date when the date format uses to 24H hour mode (HH).
/// Problem explanation: iPhone is on AM/PM mode. I want to convert a "1995-04-10 22:44:10" to a Date using "yyyy-MM-dd HH:mm:ss". Using Apple's DateFormatter, it fails to convert as you can see in the `isAMHourFormatEnabled` var.
public class MSDateFormatter {
    
    /// When `dateFormat` value is nil, the formatter uses a default date format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'".
    public var dateFormat: String?
    
    private var _dateFormat: String {
        return self.dateFormat ?? "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
    
    public init() {}
    
    private static var isAMHourFormatEnabled: Bool {
        let testDate: String = "1995-04-10 22:44:10"
        let format: String = "yyyy-MM-dd HH:mm:ss"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: testDate) == nil
    }
    
    func date(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = self._dateFormat
        let lowercasedFormat = self._dateFormat.lowercased()
        if MSDateFormatter.isAMHourFormatEnabled, lowercasedFormat.contains("hh") {
            let dateNSString = string as NSString
            let noQuotationMark = lowercasedFormat.replacingOccurrences(of: "\'", with: "").replacingOccurrences(of: "'", with: "")
            let hourRange = (noQuotationMark as NSString).range(of: "hh")
            guard dateNSString.length > hourRange.location + hourRange.length else { return nil }
            let newDateString = dateNSString.replacingCharacters(in: hourRange, with: "00")
            let hourStr = dateNSString.substring(with: hourRange)
            formatter.dateFormat = self._dateFormat.replacingOccurrences(of: "HH", with: "hh")
            if let hour = Int(hourStr) {
                if hour > 11 {
                    if let date = formatter.date(from: newDateString) {
                        return date.addingTimeInterval(TimeInterval(hour)*60*60)
                    }
                } else {
                    return formatter.date(from: string)
                }
            }
            return nil
        } else {
            return formatter.date(from: string)
        }
    }
    
    func string(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = self._dateFormat
        return formatter.string(from: date)
    }
    
}
