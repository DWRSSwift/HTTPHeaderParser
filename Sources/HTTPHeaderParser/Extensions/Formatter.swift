//
//  File.swift
//  
//
//  Created by David Stephens on 13/12/2020.
//

import Foundation

extension Formatter {
    @available(iOS 11.0, OSX 10.13, tvOS 11.0, watchOS 4.0, *)
    public static let iso8601withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    public static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    public static let rfc822: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE',' dd' 'MMM' 'yy HH':'mm':'ss z"
        return formatter
    }()
    
    public static let imfFixdate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss z"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    public static let rfc850: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z"
        return formatter
    }()
    
    public static let asctime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH':'mm':'ss yyyy"
        return formatter
    }()
    
    public static let rfc7231Formatters: [DateFormatter] = [imfFixdate, rfc850, asctime]
}

public func parseRfc7231DateString(_ date: String) -> Date? {
    for formatter in Formatter.rfc7231Formatters {
        guard let date = formatter.date(from: date) else {
            continue
        }
        return date
    }
    return nil
}
