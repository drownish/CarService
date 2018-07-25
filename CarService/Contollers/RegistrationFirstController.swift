//
//  RegistrationFirstController.swift
//  CarService
//
//  Created by Максим Белугин on 19.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegistrationFirstController: UIViewController {

    var ref: DatabaseReference!
    
    func configureDatabase() {
        ref = Database.database().reference()
        ref.child("City").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? NSArray else {
                return
            }
            self.citiesArray.removeAll()
            for city in value {
                if let i = city as? String {
                    self.citiesArray.append(i)
                }
            }
            self.citiesPopupTableView.reloadData()
        })
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if selectedCity != nil {
            self.performSegue(withIdentifier: "toSecond", sender: self)
        }
        else {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, укажите город", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
    
    
    var selectedCity: String?
    var citiesArray = ["Москва", "Екатеринбург", "Тюмень", "Пермь"]
    
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet var citiesPopupView: UIView!
    @IBOutlet weak var citiesPopupTableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    
    func closeSitiesPopup() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.citiesPopupView.alpha = 0
            self.shadowView.alpha = 0
        }, completion: { _ in
            self.shadowView.isHidden = true
            self.citiesPopupView.removeFromSuperview()
        })
        
    }
    
    func openCitiesPopup() {
        shadowView.alpha = 0
        shadowView.isHidden = false
        citiesPopupView.alpha = 0
        citiesPopupView.frame.size.width = self.view.frame.width - 58
        citiesPopupView.frame.size.height = self.view.frame.height - 180
        citiesPopupView.center = self.view.center
        self.view.addSubview(citiesPopupView)
        UIView.animate(withDuration: 0.2, animations: {
            self.citiesPopupView.alpha = 1
            self.shadowView.alpha = 0.6
        })
    }
    
    @IBAction func closePopupByTap(_ sender: Any) {
        closeSitiesPopup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityField.delegate = self
        shadowView.isHidden = true
        citiesPopupTableView.delegate = self
        citiesPopupTableView.dataSource = self
        configureDatabase()
    }

    @IBAction func endTyping(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}

extension RegistrationFirstController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as! CityCell
        cell.title.text = citiesArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityField.text = citiesArray[indexPath.row]
        selectedCity = citiesArray[indexPath.row]
        closeSitiesPopup()
    }
}


extension RegistrationFirstController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        openCitiesPopup()
        return false
    }
}
