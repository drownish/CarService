//
//  SuccesRegistrationController.swift
//  CarService
//
//  Created by Максим Белугин on 19.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class SuccesRegistrationController: UIViewController {

    @IBAction func startWorkAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toServices", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "\(UserDefaults.standard.value(forKey: "username") as! String),"
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var nameLabel: UILabel!
    

}
