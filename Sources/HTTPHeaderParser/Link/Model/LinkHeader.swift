//
//  File.swift
//  
//
//  Created by David Stephens on 26/10/2020.
//

import Foundation

public struct LinkHeader: RandomAccessCollection {
    public typealias LinksList = [LinkValue]
    
    /// The links parsed from the header
    public let links: LinksList
    /// Mapping of `rel`-> index of link to avoid iterating to find a specific link
    private let _linksByRel: [String: Int]
    
    struct Constructor {
        private var links: [LinkValue] = []
        private var _linksByRel: [String: Int] = [:]
        
        
        mutating func add(link: LinkValue) {
            links.append(link)
            if let rel = link.params.rel {
                _linksByRel.updateValue(links.endIndex-1, forKey: rel)
            }
        }
        
        func toLinkHeader() -> LinkHeader {
            return LinkHeader(links: self.links, _linksByRel: self._linksByRel)
        }
    }

    public typealias Element = LinksList.Element
    public typealias Index = LinksList.Index

    // The upper and lower bounds of the collection, used in iterations
    public var startIndex: Index { return links.startIndex }
    public var endIndex: Index { return links.endIndex }

    // Required subscript, based on a dictionary index
    public subscript(index: Index) -> Iterator.Element {
        get { return links[index] }
    }

    // Method that returns the next index when iterating
    public func index(after i: Index) -> Index {
        return links.index(after: i)
    }
}

public extension LinkHeader {
    subscript(rel rel: String) -> LinkValue? {
        get {
            guard let index = _linksByRel[rel] else {
                return nil
            }
            return links[index]
        }
    }
}
