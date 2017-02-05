//
//  Car.swift
//  ViewControllerInjection
//
//  Created by Daniel Hall on 10/21/16.
//  Copyright © 2016 Daniel Hall. All rights reserved.
//

import Foundation

class Car: CustomStringConvertible {
    let year:Int
    let make:String
    let model:String
    var mileage:Int
    var description: String { return "<Car>: \(year) \(make) \(model) with \(mileage) miles" }
    init(year:Int, make:String, model:String, mileage:Int) {
        self.year = year
        self.make = make
        self.model = model
        self.mileage = mileage
    }
}

protocol CarInjected : Injected { }

extension CarInjected {
    var car:Car {
        get {
            return Injectable.get(traitName: #function, for: injectableIdentifier, orDefaultTo: CarInjector.carToInject())
        } set {
            Injectable.set(traitName: #function, for: &injectableIdentifier, to: newValue)
        }
    }
}

struct CarInjector {
    private static var nextInjectedCar:Car?
    static var carToInject:()->Car = {
        let nextInjected = nextInjectedCar
        nextInjectedCar = nil // Nuke this value so it isn't used for future objections, only this one
        return nextInjected ?? Car(year:0, make:"Default", model:"Default", mileage:1000)
    }
    static func setNextInjectedCar(_ car:Car?) {
        nextInjectedCar = car
    }
}
