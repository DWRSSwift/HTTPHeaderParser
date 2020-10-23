//
//  File.swift
//  
//
//  Created by David Stephens on 24/10/2020.
//

import Foundation

/// The parameters associated with a `link-value`.
public struct LinkParams: Equatable, Hashable {
    public let rel: String?
    public let anchor: String?
    public let rev: String?
    public let hreflang: [String]?
    public let media: String?
    public let title: String?
    public let titleStar:String?
    public let type: String?
}
