//
//  File.swift
//  
//
//  Created by David Stephens on 25/10/2020.
//

import Foundation
import Sweep

/**
 Splits the parameters of a `link-value`
 
 - Parameter string: The `link-value` to process.
 - Parameter previousParams: List of targets to which the extracted params should be appended.
 
 - Returns: A list where every element is a key-value pair representing a parameter.
 
 */
func splitLinkParams<S: StringProtocol>(in string: S, appendedTo previousParams: [String] = []) -> [String] {
    var updatedTargets = previousParams
    let trimmedString = string.trimmingCharacters(in: .whiteSpacesNewLinesAndSemiColon)
    let trimmedStringEnd = trimmedString.endIndex
    
    var paramString: String = ""
    var hasSeenQuote = false
    for (i, char) in trimmedString.enumerated() {
        let index = String.Index(utf16Offset: i, in: trimmedString)
        switch char {
        case QuoteChar:
            hasSeenQuote.toggle()
        case SemiColonChar where !hasSeenQuote:
            updatedTargets.append(paramString)
            return splitLinkParams(in:  trimmedString[index..<trimmedStringEnd], appendedTo: updatedTargets)
        default:
            break
        }
        paramString.append(char)
    }
    updatedTargets.append(paramString)
    return updatedTargets
}

extension HTTPHeaderParser {
    public enum Link {
        /**
         Parses a HTTP `Link` Header into a series of `link-value`s as per [RFC 5988](https://tools.ietf.org/html/rfc5988#section-5).
         
         - Parameter value: The value of the `Link` header.
         */
        public static func parse(value: String) -> [LinkValue] {
            let linkValues = value.split(separator: ",")
            let linkParams = linkValues.compactMap { linkValue -> LinkValue? in
                guard let uriRef = URIReference(from: linkValue) else {
                    return nil
                }
                let linkParams = splitLinkParams(in: uriRef.remaining)
                let parms = LinkParams(from: linkParams)
                return LinkValue(target: uriRef.value, params: parms)
            }
            return linkParams
        }
    }
}
