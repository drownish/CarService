//
//  RegistrationThirdController.swift
//  CarService
//
//  Created by Максим Белугин on 19.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import PhoneNumberKit


class RegistrationThirdController: UIViewController {

    
    
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        if nameField.text == "" || nameField.text == nil || nameField.text == " " || phoneField.text == "" || phoneField.text == " " || phoneField.text == nil {
            print("err")
            let alert = UIAlertController(title: "Ошибка", message: "Введите все данные", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            UserDefaults.standard.set(nameField.text, forKey: "username")
            UserDefaults.standard.set(phoneField.text, forKey: "phone")
            UserDefaults.standard.set(true, forKey: "isRegistered")
            self.performSegue(withIdentifier: "toSucces", sender: self)
        }
    }
    
   
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var spaceUpstairs: NSLayoutConstraint!
    
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var spaceBetweenFields: NSLayoutConstraint!
    
    @objc func keyboardWillShow() {
        headerHeight.constant = 0
        spaceBetweenFields.constant = 12
        spaceUpstairs.constant = 0
        
        //subtitle.font = UIFont(name: "ofont.ru_Glober", size: 18)
        UIView.animate(withDuration: 0.1, animations: {
            self.mainTitle.alpha = 0
            self.view.layoutIfNeeded()
        })
        
    }
    
    @objc func keyboardWillHide() {
        headerHeight.constant = 43.5
        spaceBetweenFields.constant = 52
        spaceUpstairs.constant = 22
        //subtitle.font = UIFont(name: "ofont.ru_Glober", size: 26)
        UIView.animate(withDuration: 0.1, animations: {
            self.mainTitle.alpha = 1
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func endTyping(_ sender: Any) {
        print("tap")
        self.view.endEditing(true)
    }
    
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: PhoneNumberTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneField.defaultRegion = "RU"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    

}
