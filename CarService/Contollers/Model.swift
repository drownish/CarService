//
//  Model.swift
//  CarService
//
//  Created by Максим Белугин on 24.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

var selectedServices = [SelectedService]()
var allServices = [[ClassService: [TypeService]]]()
var mainService = [ClassService: [TypeService]]()
var loaded = false

class DatabaseHandler {
    
    var ref: DatabaseReference!
    var classes = [ClassService]()
    var types = [TypeService]()
    
    
    
    func loadServices() {
        ref = Database.database().reference()
        ref.child("ClassService").observeSingleEvent(of: .value, with: { snapshot in
            guard let raw = snapshot.value as? NSArray else {
                print("errororor")
                return
            }
            var value = [NSDictionary]()
            
            for i in 0...raw.count-1 {
                if let z = raw[i] as? NSDictionary {
                    value.append(z)
                }
            }
           
            for clas in value {
                let img = clas["Image"] as! String
                let isMain = clas["IsMain"] as! String
                let name = clas["Name"] as! String
                self.classes.append(ClassService(image: img, isMain: isMain, name: name))
            }
            for i in self.classes {
                allServices.append([i:[]])
            }
            self.loadTypes()
        })
    }
    
    func loadTypes() {
        ref.child("TypeService").observeSingleEvent(of: .value, with: { snapshot in
            guard let raw = snapshot.value as? NSArray else {
                print("errororor")
                return
            }
            var value = [NSDictionary]()
            
            for i in 0...raw.count-1 {
                if let z = raw[i] as? NSDictionary {
                    value.append(z)
                }
            }
            for type in value {
                let clas = type["Class"] as! Int
                let descript = type["Description"] as! String
                let detailDescript = type["DetailDescription"] as? String
                let name = type["Name"] as! String
                let price = type["Price"] as! Int
                self.types.append(TypeService(clas: clas, descript: descript, detailDescript: detailDescript, name: name, price: price))
            }
            
            for type in self.types {
                var wasArray = allServices[type.clas-1].first!.value
                wasArray.append(type)
                allServices[type.clas-1] = [allServices[type.clas-1].first!.key: wasArray]
            }
            var index = 0
            for i in allServices {
                let x = i.first!
                
                for z in x.value {
                    if z.price < i.first!.key.fromPrice {
                        allServices[index].first!.key.fromPrice = z.price
                    }
                }
                
                if i.first!.key.isMain == "True" {
                    mainService = i
                    allServices.remove(at: index)
                } else {
                    index += 1
                }
                
                
            }
            
            
            NotificationCenter.default.post(name: NSNotification.Name("loaded"), object: nil)
            loaded = true
            print(allServices)
            
        })
    }
    
}

class ClassService: NSObject {
    var image: String
    var isMain: String
    var name: String
    var fromPrice: Int
    init(image: String, isMain: String, name: String) {
        self.image = image
        self.isMain = isMain
        self.name = name
        self.fromPrice = 10000000
    }
}


class TypeService: NSObject {
    var clas: Int
    var descript: String
    var detailDescript: String?
    var name: String
    var price: Int
    
    init(clas: Int, descript: String, detailDescript: String?, name: String, price: Int)  {
        self.clas = clas
        self.descript = descript
        self.detailDescript = detailDescript
        self.name = name
        self.price = price
    }
}

class SelectedService {
    var service: TypeService
    var date: Date
    var priceWithDiscount: Int
    init(service: TypeService, date: Date, priceWithDiscount: Int) {
        self.service = service
        self.date = date
        self.priceWithDiscount = priceWithDiscount
    }
}















