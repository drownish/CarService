//
//  StartController.swift
//  CarService
//
//  Created by Максим Белугин on 19.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class StartController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "isRegistered") as? Bool == true {
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                self.performSegue(withIdentifier: "toServices", sender: self)
            })
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                self.performSegue(withIdentifier: "toRegistration", sender: self)
            })
        }
        
    }
}
