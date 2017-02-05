//
//  ViewController.swift
//  InjectableExample
//
//  Created by Daniel Hall on 10/24/16.
//  Copyright © 2016 Daniel Hall. All rights reserved.
//

import UIKit

import UIKit

class CarListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let carList = [Car(year:2014, make:"Toyota", model:"Camry", mileage:72369),
                   Car(year:2012, make:"Acura", model:"Legend", mileage:63726),
                   Car(year:2006, make:"Ford", model:"Focus", mileage:92827),
                   Car(year:2009, make:"Chevrolet", model:"Malibu", mileage:26363),
                   Car(year:2015, make:"Porsche", model:"Cayenne", mileage:10982),
                   Car(year:2008, make:"Buick", model:"Regal", mileage:88372),
                   Car(year:2011, make:"Honda", model:"Civic", mileage:54632),
                   Car(year:2016, make:"Audi", model:"A4", mileage:2349),
                   Car(year:2013, make:"Cadillac", model:"Escalade", mileage:32987),
                   Car(year:2010, make:"Jeep", model:"Liberty", mileage:54827),
                   ]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for:  indexPath) as! CarTableViewCell
        cell.car = carList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        CarInjector.setNextInjectedCar(carList[indexPath.row])
        return indexPath
    }
    
}

class CarTableViewCell: UITableViewCell {
    @IBOutlet private var yearLabel:UILabel!
    @IBOutlet private var makeLabel:UILabel!
    @IBOutlet private var modelLabel:UILabel!
    @IBOutlet private var mileageLabel:UILabel!
    
    var car:Car? {
        didSet {
            guard let car = car else { return }
            yearLabel.text = String(car.year)
            makeLabel.text = car.make
            modelLabel.text = car.model
            mileageLabel.text = "\(car.mileage) miles"
        }
    }
}


class CarDetailViewController: UIViewController, CarInjected {
    var injectableIdentifier = InjectableIdentifier()
    @IBOutlet private var yearLabel:UILabel! { didSet { yearLabel.text = String(car.year) } } //
    @IBOutlet private var makeLabel:UILabel! { didSet { makeLabel.text = car.make } }
    @IBOutlet private var modelLabel:UILabel! { didSet { modelLabel.text = car.model } }
    @IBOutlet private var mileageLabel:UILabel! { didSet { mileageLabel.text = "\(car.mileage) miles" } }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Look! I have a non-optional, mutable, injected car property at initialization, and the value is: \(car)")
        car.mileage = 50000 // We change the mileage from whatever it originally was in the injected value to 50,000. Let's see if this reflects in the label that is set when it's connected...
        print("Mutated the injected car property during initialization to have 50,000 miles")
    }
    
}
