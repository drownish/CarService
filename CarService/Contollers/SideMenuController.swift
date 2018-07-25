//
//  SideMenuController.swift
//  CarService
//
//  Created by Максим Белугин on 23.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class SideMenuController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }


    @IBOutlet weak var tableView: UITableView!
    
}


extension SideMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell") as! SideMenuCell
        return cell
    }
    
}
