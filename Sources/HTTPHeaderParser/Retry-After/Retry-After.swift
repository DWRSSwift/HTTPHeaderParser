//
//  File.swift
//  
//
//  Created by David Stephens on 13/12/2020.
//

import Foundation

extension HTTPHeaderParser {
    public enum RetryAfter {
        public static func parse(value: String) -> RetryAfterHeader? {
            if let intValue = Int(value) {
                let retryInterval = TimeInterval(intValue)
                return RetryAfterHeader(retryDate: Date().addingTimeInterval(retryInterval))
            }
            
            if let date = parseRfc7231DateString(value) {
                return RetryAfterHeader(retryDate: date)
            }
            
            return nil
        }
    }
}
