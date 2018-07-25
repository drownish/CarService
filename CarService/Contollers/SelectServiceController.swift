//
//  SelectServiceController.swift
//  CarService
//
//  Created by Максим Белугин on 25.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class SelectServiceController: UIViewController {

    var type: TypeService!
    var backgroundImage = UIImage()
    var selectedDate = Date()
    let calendar = Calendar.current
    let date = Date()
    var totalPrice = Int()
    
    
    @IBAction func changeDateAction(_ sender: Any) {
        showPopup()
    }
    
   
    
    
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var popupDatePicker: UIDatePicker!
    @IBAction func closePopupAction(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: {
            self.shadowView.alpha = 0
            self.popupView.alpha = 0
        }, completion: { _ in
            self.shadowView.isHidden = true
            self.popupView.removeFromSuperview()
        })
        selectedDate = popupDatePicker.date
        let month = calendar.component(.month, from: selectedDate)
        dateTitle.text = "\(calendar.component(.day, from: selectedDate)) \(calendar.getString(month: month))"
        let minute = calendar.component(.minute, from: selectedDate)
        if String(minute).characters.count < 2 {
            timeTitle.text = "\(calendar.component(.hour, from: selectedDate)):0\(minute)"
        }
        else {
            timeTitle.text = "\(calendar.component(.hour, from: selectedDate)):\(minute)"
        }
        let dateAfter14Days = date.addingTimeInterval(14*24*60*60)
        if selectedDate >= dateAfter14Days {
            discountTitle.text = "15%"
            getDiscountTitle.text = "Скидка активирована"
            totalPriceTitle.text = "Итого за услугу: \(type.price-15*(type.price/100)) руб."
            totalPrice = type.price-15*(type.price/100)
        }
        else {
            discountTitle.text = "10%"
            let day = calendar.component(.day, from: dateAfter14Days)
            let month = calendar.component(.month, from: dateAfter14Days)
            getDiscountTitle.text = "Получите +5% скидку, оформив запись с \(day) \(calendar.getString(month: month))"
            totalPriceTitle.text = "Итого за услугу: \(type.price-10*(type.price/100)) руб."
            totalPrice = type.price-10*(type.price/100)
        }
        
        
    }
    
    func showPopup() {
        
        shadowView.alpha = 0
        shadowView.isHidden = false
        popupView.alpha = 0
        popupView.frame.size.width = self.view.frame.width-40
        popupView.frame.size.height = self.view.frame.width
        popupView.center = self.view.center
        popupDatePicker.date = selectedDate
        self.view.addSubview(popupView)
        UIView.animate(withDuration: 0.2, animations: {
            self.shadowView.alpha = 0.6
            self.popupView.alpha = 1
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.isHidden = true
        backgroundPhoto.image = backgroundImage
        mainTitle.text = "Выбор времени"
        subtitle.text = type.descript
        discountTitle.text = "\(10)%"
        totalPriceTitle.text = "Итого за услугу: \(type.price-10*(type.price/100)) руб."
        totalPrice = type.price-10*(type.price/100)
        
        
        
        let dateAfter14Days = date.addingTimeInterval(14*24*60*60)
        
        let day = calendar.component(.day, from: dateAfter14Days)
        let month = calendar.component(.month, from: dateAfter14Days)
        getDiscountTitle.text = "Получите +5% скидку, оформив запись с \(day) \(calendar.getString(month: month))"
        let dateTomorrow = date.addingTimeInterval(24*60*60)
        selectedDate = dateTomorrow
        let monthTomorrow = calendar.component(.month, from: dateTomorrow)
        
        dateTitle.text = "\(calendar.component(.day, from: dateTomorrow)) \(calendar.getString(month: monthTomorrow))"
        
        
    }

    @IBOutlet weak var mainTitle: UILabel!
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backgroundPhoto: UIImageView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var discountTitle: UILabel!
    @IBOutlet weak var totalPriceTitle: UILabel!
    @IBOutlet weak var getDiscountTitle: UILabel!
    
}

extension Calendar {
    func getString(month: Int) -> String {
        switch month {
        case 1:
            return "января"
        case 2:
            return "февраля"
        case 3:
            return "марта"
        case 4:
            return "апреля"
        case 5:
            return "мая"
        case 6:
            return "июня"
        case 7:
            return "июля"
        case 8:
            return "августа"
        case 9:
            return "сентября"
        case 10:
            return "октября"
        case 11:
            return "ноября"
        case 12:
            return "декабря"
        default:
            return ""
        }
    }
}




