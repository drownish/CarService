//
//  RegistrationSecondController.swift
//  CarService
//
//  Created by Максим Белугин on 19.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegistrationSecondController: UIViewController {

    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    var ref: DatabaseReference!
    
    func configureBrands() {
        ref = Database.database().reference()
        var brands = [String]()
        ref.child("MarkAuto").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? NSArray else {
                return
            }
            for i in value {
                if let x = i as? String {
                    brands.append(x)
                }
            }
            
            for brand in brands {
                self.brandnames.append([brand : []])
            }
            
            self.configureMarksWith(brands: brands)
            
            
        })
    }
    
    func configureMarksWith(brands: [String]) {
        ref = Database.database().reference()
        ref.child("ModelAuto").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? NSArray else {
                return
            }
            
            for mod in value {
                if let model = mod as? NSDictionary {
                    for i in 0...self.brandnames.count-1 {
                        if brands[model["MarkAuto"] as! Int-1] == self.brandnames[i].first!.key {
                            var wasArray = self.brandnames[i].first!.value
                            wasArray.append(model["ModelAuto"] as! String)
                            self.brandnames[i][self.brandnames[i].first!.key] = wasArray
                        }
                    }
                }
                
            }
            print(self.brandnames)
        })
    }
    
    
    var brandnames = [[String: [String]]]()
    var typeOfEditing = 0
    
    var selectedBrand: String?
    var selectedBrandInt = Int()
    var selectedModel: String?
    
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var popupTableView: UITableView!
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var modelField: UITextField!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    
    
    @IBAction func closePopupByTap(_ sender: Any) {
        closePopup()
    }
    
    
    
    func showPopup() {
        if typeOfEditing == 0 {
            popupTitle.text = "Выберите марку"
        }
        else {
            popupTitle.text = "Выберите модель"
        }
        shadowView.alpha = 0
        shadowView.isHidden = false
        popupView.alpha = 0
        popupView.frame.size.width = self.view.frame.width - 58
        popupView.frame.size.height = self.view.frame.height - 180
        popupView.center = self.view.center
        self.view.addSubview(popupView)
        popupTableView.reloadData()
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.alpha = 1
            self.shadowView.alpha = 0.6
        })
        
    }
    
    func closePopup() {
        UIView.animate(withDuration: 0.2, animations: {
            self.popupView.alpha = 0
            self.shadowView.alpha = 0
        }, completion: { _ in
            self.shadowView.isHidden = true
            self.popupView.removeFromSuperview()
        })
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if selectedModel != nil && selectedBrand != nil {
            self.performSegue(withIdentifier: "toThird", sender: self)
            print("ok")
        }
        else {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, введите все данные", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.isHidden = true
        popupTableView.delegate = self
        popupTableView.dataSource = self
        modelField.delegate = self
        brandField.delegate = self
        configureBrands()
    }
    
}


extension RegistrationSecondController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if typeOfEditing == 0 {
            return brandnames.count
        }
        else {
            return brandnames[selectedBrandInt].first!.value.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popupCell") as! PopupCell
        if typeOfEditing == 0 {
            cell.title.text = brandnames[indexPath.row].first?.key
        }
        else {
            cell.title.text = brandnames[selectedBrandInt].first!.value[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if typeOfEditing == 0 {
            selectedBrand = brandnames[indexPath.row].first!.key
            selectedBrandInt = indexPath.row
            brandField.text = selectedBrand
            modelField.text = ""
            UserDefaults.standard.set(selectedBrand, forKey: "selectedBrand")
            closePopup()
        }
        else {
            
            selectedModel = brandnames[selectedBrandInt].first!.value[indexPath.row]
            modelField.text = selectedModel
            UserDefaults.standard.set(selectedModel, forKey: "selectedModel")
            closePopup()
        }
    }
    
}

extension RegistrationSecondController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == brandField {
            typeOfEditing = 0
            showPopup()
        }
        else {
            if selectedBrand != nil {
                typeOfEditing = 1
                showPopup()
            }
            else {
                let alert = UIAlertController(title: "Укажите марку автомобиля", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Oк", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
        }
        return false
    }
}


