//
//  ServiceController.swift
//  CarService
//
//  Created by Максим Белугин on 24.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

protocol ServiceTableCellDelegate {
    func openPopupWithIndex(_ index: Int)
}

class ServiceController: UIViewController, ServiceTableCellDelegate {
    
    var clas: ClassService!
    var types = [TypeService]()
    var backgroundPhoto = UIImage()
    
    func openPopupWithIndex(_ index: Int) {
        shadowView.alpha = 0
        shadowView.isHidden = false
        popupView.alpha = 0
        popupView.frame.size.width = self.view.frame.width - 42
        popupView.frame.size.height = self.view.frame.height - 184
        popupView.center = self.view.center
        
        
        popupTitle.text = "\(types[index].descript), \(types[index].name)"
        popupDescription.text = types[index].detailDescript ?? ""
        
        
        
        self.view.addSubview(popupView)
        UIView.animate(withDuration: 0.2, animations: {
            self.shadowView.alpha = 0.6
            self.popupView.alpha = 1
        })
    }
    

    
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var popupDescription: UITextView!
    
    
    
    
    
    @IBAction func closePopupAction(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.shadowView.alpha = 0
            self.popupView.alpha = 0
        }, completion: { _ in
            self.shadowView.isHidden = true
            self.popupView.removeFromSuperview()
        })
    }
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        shadowView.isHidden = true
        mainTitle.text = clas.name
        backgroundImage.image = backgroundPhoto

    }

  
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectService" {
            let dest = segue.destination as! SelectServiceController
            dest.backgroundImage = backgroundPhoto
            dest.type = types[tableView.indexPathForSelectedRow!.row]
            
        }
    }
    
}


extension ServiceController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceTableCell") as! ServiceTableCell
        cell.selfIndex = indexPath.row
        cell.delegate = self
        cell.mainTitle.text = types[indexPath.row].name
        cell.subtitle.text = types[indexPath.row].descript
        cell.price.text = "\(types[indexPath.row].price) руб."
        return cell
    }
    
    
}
