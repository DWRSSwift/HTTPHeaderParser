//
//  File.swift
//  
//
//  Created by David Stephens on 25/10/2020.
//

import Foundation

extension CharacterSet {
    static let whiteSpacesNewLinesAndSemiColon: CharacterSet = {
        var charSet: CharacterSet = .whitespacesAndNewlines
        charSet.insert(charactersIn: ";")
        return charSet
    }()
}
