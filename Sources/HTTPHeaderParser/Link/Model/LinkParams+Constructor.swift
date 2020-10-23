//
//  File.swift
//  
//
//  Created by David Stephens on 24/10/2020.
//

import Foundation

extension LinkParams {
    /// Intermediary (mutable) version of the `LinkParams` struct used during construction.
    struct Constructor {
        var rel: String? = nil
        var anchor: String? = nil
        var rev: String? = nil
        var hreflang: [String]? = nil
        var media: String? = nil
        var title: String? = nil
        var titleStar:String? = nil
        var type: String? = nil
        
        init() {}
        
        mutating func update<N: StringProtocol>(_ value: String, forParam paramName: N) {
            switch paramName {
            case "rel":
                /*
                 https://tools.ietf.org/html/rfc5988#section-5.3
                 The "rel" parameter MUST NOT appear more than once in a given
                    link-value; occurrences after the first MUST be ignored by parsers.
                 */
                guard self.rel == nil else {
                    return
                }
                self.rel = value
            case "anchor":
                self.anchor = value
            case "rev":
                self.rev = value
            case "hreflang":
                guard self.hreflang != nil else {
                    self.hreflang = [value]
                    return
                }
                self.hreflang?.append(value)
            case "media":
                // "there MUST NOT be more than one "media" parameter in a link-value."
                guard self.media == nil else {
                    return
                }
                self.media = value
            case "title":
                /* The "title" parameter MUST NOT appear
                    more than once in a given link-value; occurrences after the first
                    MUST be ignored by parsers.
                 */
                guard self.title == nil else {
                    return
                }
                self.title = value
            case "type":
                // There MUST NOT be more than one type parameter in a link- value
                guard self.type == nil else {
                    return
                }
                self.type = value
            default:
                break
            }
        }
        
        func toLinkParams() -> LinkParams {
            return LinkParams(rel: self.rel,
                              anchor: self.anchor,
                              rev: self.rev,
                              hreflang: self.hreflang,
                              media: self.media,
                              title: self.title,
                              titleStar: self.titleStar,
                              type: self.type
            )
        }
    }
    
    /**
     Initialises the struct based on the key-value pairs in the array.
     
     - Requires: The elements of the list to be key-value pairs separated by an `=`.
     */
    init<S: StringProtocol>(from params: [S]) {
        var linkParams = Constructor()
        params.forEach { param in
            guard let separatorIndex = param.firstIndex(of: "=") else {
                return
            }
            let name = param[param.startIndex..<separatorIndex]
            let indexAfterSeparator = param.index(after: separatorIndex)
            let charSet = CharacterSet(charactersIn: "\"")
            let value = param[indexAfterSeparator..<param.endIndex].trimmingCharacters(in: charSet)
            linkParams.update(String(value), forParam: name)
        }
        self = linkParams.toLinkParams()
    }
}
