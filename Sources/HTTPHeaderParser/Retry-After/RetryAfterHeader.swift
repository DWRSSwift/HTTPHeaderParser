//
//  File.swift
//  
//
//  Created by David Stephens on 13/12/2020.
//

import Foundation

@frozen
public struct RetryAfterHeader {
    public let retryDate: Date
    
    /**
     Returns the seconds until retry is allowed.
     
     - Returns: The TimeInterval until retry is allowed. If retry date is in the past, returns 0
     */
    public func secondsTilRetry() -> TimeInterval {
        let seconds = retryDate.timeIntervalSince(Date())
        guard seconds > 0 else {
            return 0
        }
        return seconds
    }
    
    public func canRetry() -> Bool {
        secondsTilRetry() == 0
    }
}
