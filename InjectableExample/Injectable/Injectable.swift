//
//  Injectable.swift
//  InjectableExample
//
//  Created by Daniel Hall on 2/5/17.
//  Copyright © 2017 Daniel Hall. All rights reserved.
//

import Foundation

protocol Injected {
    var injectableIdentifier: InjectableIdentifier { get set }
}

class InjectableIdentifier {
    fileprivate var id:Int { return ObjectIdentifier(self).hashValue }
}

private class TraitIdentifier : Hashable {
    fileprivate weak var injectableIdentifier:InjectableIdentifier?
    private let initialHash:Int
    private let traitName:String
    var hashValue: Int { return initialHash ^ traitName.hashValue }
    init(injectableIdentifier:InjectableIdentifier, traitName:String) {
        self.injectableIdentifier = injectableIdentifier
        initialHash = injectableIdentifier.id
        self.traitName = traitName
    }
}

private func ==(left:TraitIdentifier, right:TraitIdentifier) -> Bool {
    return left.hashValue == right.hashValue
}

enum Injectable {
    // Global storage dictionary for all injected traits, stored by a key that associates each value with a specific instance + traitName
    private static var injectedTraits = [TraitIdentifier : Any]()
    
    // Get a trait with the supplied name associated with the supplied InjectableIdentifier
    static func get<T>(traitName:String, for identifier:InjectableIdentifier) -> T? {
        pruneInjectedValues()
        let traitIdentifier = TraitIdentifier(injectableIdentifier: identifier, traitName: traitName)
        return injectedTraits[traitIdentifier] as? T
    }
    
    // Get a trait with the supplied name associated with the supplied InjectableIdentifier. If no value for that trait name exists, set it to the supplied default and return that
    static func get<T>(traitName:String, for identifier:InjectableIdentifier, orDefaultTo value:T) -> T {
        pruneInjectedValues()
        let traitIdentifier = TraitIdentifier(injectableIdentifier: identifier, traitName: traitName)
        if (injectedTraits[traitIdentifier] as? T) == nil {
            injectedTraits[traitIdentifier] = value
        }
        return injectedTraits[traitIdentifier] as! T
    }
    
    // Set a trait with the supplied name associated with the supplied InjectableIdentifier to the supplied value
    static func set<T>(traitName:String, for identifier:inout InjectableIdentifier, to value:T) {
        pruneInjectedValues()
        if !isKnownUniquelyReferenced(&identifier) {
            identifier = InjectableIdentifier()
        }
        let traitIdentifier = TraitIdentifier(injectableIdentifier: identifier, traitName: traitName)
        injectedTraits[traitIdentifier] = value
    }
    
    // Remove any stored values whose associated instances have been deallocated
    static func pruneInjectedValues() {
        injectedTraits.keys.filter{ trait in trait.injectableIdentifier == nil }.forEach{ trait in injectedTraits[trait] = nil }
    }
}
