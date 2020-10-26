//
//  File.swift
//  
//
//  Created by David Stephens on 24/10/2020.
//

import Foundation

/// Represents a single link in the header
public struct LinkValue: Equatable, Hashable {
    /// The target (i.e. uri-reference) of the link
    public let target: String
    /// The various parameters associated with this link
    public let params: LinkParams
    
    public init(target: String, params: LinkParams) {
        self.target = target
        self.params = params
    }
}
