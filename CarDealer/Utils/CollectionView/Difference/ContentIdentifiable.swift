//
//  ContentIdentifiable.swift
//  CollectionView
//
//  Created by Deniz Kaplan on 21/12/2022.
//

import Foundation

public typealias Differentiable = ContentIdentifiable & ContentEquatable

/// Represents the value that identified for differentiate.
public protocol ContentIdentifiable {
    /// A type representing the identifier.
    associatedtype DifferenceIdentifier: Hashable

    /// An identifier value for difference calculation.
    var differenceIdentifier: DifferenceIdentifier { get }
}

public extension ContentIdentifiable where Self: Hashable {
    /// The `self` value as an identifier for difference calculation.
    @inlinable
    var differenceIdentifier: Self {
        self
    }
}

/// Represents the section of collection that can be identified and compared to whether has updated.
public protocol DifferentiableSection: Differentiable {
    /// A type representing the elements in section.
    associatedtype Collection: Swift.Collection where Collection.Element: Differentiable

    /// The collection of element in the section.
    var elements: Collection { get }

    /// Creates a new section reproducing the given source section with replacing the elements.
    ///
    /// - Parameters:
    ///   - source: A source section to reproduce.
    ///   - elements: The collection of elements for the new section.
    init<C: Swift.Collection>(source: Self, elements: C) where C.Element == Collection.Element
}
