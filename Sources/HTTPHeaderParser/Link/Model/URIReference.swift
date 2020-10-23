//
//  File.swift
//  
//
//  Created by David Stephens on 24/10/2020.
//

import Foundation
import Sweep

struct URIReference {
    /// The value of the URI
    let value: String
    /// The Index after the "Target IRI" (i.e. after the right angled bracket)
    let remaining: String.SubSequence
    
    init(value: String, remaining: String.SubSequence) {
        self.value = value
        self.remaining = remaining
    }
    
    /**
        Parses a HTTP `Link` header into a `URIReference`
     
     */
    init?<S: StringProtocol>(from link: S) where S.SubSequence == Substring {
        var scannedUriRef: Substring? = nil
        var uriRefEnd: String.Index? = nil
        // The URI starts after the left angle bracket (https://tools.ietf.org/html/rfc5988#section-5.1)
        link.scan(using: [
            Matcher(identifier: "<", terminator: ">", allowMultipleMatches: false, handler: { (uriRef, range) in
                scannedUriRef = uriRef
                uriRefEnd = range.upperBound
            })
        ])
        guard let uriRef = scannedUriRef,
              let indexAfterUriRefEnd = uriRefEnd.map({ link.index(after: $0) }) else {
            return nil
        }
        
        self.value = String(uriRef)
        self.remaining = link[indexAfterUriRefEnd..<link.endIndex]
    }
}
