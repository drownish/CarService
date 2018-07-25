//
//  ServiceCell.swift
//  CarService
//
//  Created by Максим Белугин on 23.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit

class ServiceCell: UICollectionViewCell {
   
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var priceTitle: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    func startLoading() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        mainTitle.alpha = 0
        priceTitle.alpha = 0

        
    }
    
    func stopLoading() {
        loadingIndicator.isHidden = true
        mainTitle.alpha = 1
        priceTitle.alpha = 1
   
    }
    
}
