//
//  MainServicesController.swift
//  CarService
//
//  Created by Максим Белугин on 23.07.2018.
//  Copyright © 2018 Максим Белугин. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class MainServicesController: UIViewController {

    let storage = Storage.storage()
    
    var imagesForCollection = [Int: UIImage]()
    @IBOutlet weak var shadowView: UIView!
    var opened = false
    
    @IBAction func sideMenuAction(_ sender: Any) {
        revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func mainServiceAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toService", sender: self)
    }
    @IBOutlet weak var mainServiceButton: UIButton!
    
    
    @IBOutlet weak var mainServiceLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainServiceTitle: UILabel!
    @IBOutlet weak var mainServicePrice: UILabel!
    
    @IBOutlet weak var mainServiceBackground: UIImageView!
    
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!

    override func viewDidAppear(_ animated: Bool) {
        collectionViewHeight.constant = self.view.frame.height - mainServiceBackground.frame.height
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            self.shadowView.alpha = 0
        })
        servicesCollectionView.deselectAllItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        servicesCollectionView.alwaysBounceVertical = true
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        shadowView.alpha = 0
        servicesCollectionView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            servicesCollectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loaded), name: NSNotification.Name("loaded"), object: nil)
        self.mainServiceLoadingIndicator.isHidden = false
        mainServiceLoadingIndicator.startAnimating()
        self.mainServicePrice.alpha = 0
        self.mainServiceTitle.alpha = 0
        loadImages()
        setMainService()
        mainServiceButton.isHidden = true
        
    }
    
    func setMainService() {
        if !mainService.isEmpty {
            
            mainServiceTitle.text = mainService.first!.key.name
            mainServicePrice.text = "от \(mainService.first!.key.fromPrice) руб."
            let img = mainService.first!.key.image
            let ref = storage.reference(withPath: img)
            ref.getData(maxSize: 1 * 1024 * 1024, completion: { data, error in
                print("img loading")
                if error != nil {
                    print("err")
                }
                else {
                    self.mainServiceBackground.image = UIImage(data: data!)
                    self.mainServiceLoadingIndicator.isHidden = true
                    self.mainServicePrice.alpha = 1
                    self.mainServiceTitle.alpha = 1
                    self.mainServiceButton.isHidden = false
                }
                
            })
            
        }
    }
    
    @objc func loaded() {
        servicesCollectionView.reloadData()
        setMainService()
        loadImages()
        
    }

    func loadImages() {
        print("loadingStarted")
        if allServices.isEmpty {
            return
        }
        for (i,x) in zip(allServices, 0...allServices.count-1) {
            let img = i.first!.key.image
            let ref = storage.reference(withPath: img)
            ref.getData(maxSize: 1 * 1024 * 1024, completion: { data, error in
                print("img loading")
                if error != nil {
                    print("err")
                }
                else {
                    self.imagesForCollection[x] = (UIImage(data: data!) ?? UIImage())
                    self.servicesCollectionView.reloadData()
                }
                
            })
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toService" {
            let destination = segue.destination as! ServiceController
            if servicesCollectionView.indexPathsForSelectedItems == nil {
                return
            }
            if let selected = servicesCollectionView.indexPathsForSelectedItems!.first {
                destination.clas = allServices[selected.row].first!.key
                destination.types = allServices[selected.row].first!.value
                destination.backgroundPhoto = imagesForCollection[selected.row]!
            }
            else {
                destination.clas = mainService.first!.key
                destination.types = mainService.first!.value
                destination.backgroundPhoto = mainServiceBackground.image!
            }
            
        }
    }
    

}

extension MainServicesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "serviceCell", for: indexPath) as! ServiceCell
        cell.mainTitle.text = allServices[indexPath.row].first!.key.name
        cell.priceTitle.text = "от \(allServices[indexPath.row].first!.key.fromPrice) руб."
        if indexPath.row < imagesForCollection.count {
            cell.backgroundImage.image = imagesForCollection[indexPath.row]
            cell.stopLoading()
        } else {
            cell.startLoading()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width
        return CGSize(width: (width-42)/2, height: (width-42)/2)
    }
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toService", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if imagesForCollection[indexPath.row] != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            collectionViewHeight.constant = self.view.frame.height - mainServiceBackground.frame.height
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.shadowView.alpha = 0
            })
            opened = false
        }
        else if scrollView.contentOffset.y != 0{
            
                collectionViewHeight.constant = self.view.frame.height - 104
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    self.shadowView.alpha = 0.6
                })
            
        }
    }
    

    
   
    
    
}



extension UICollectionView {
    func deselectAllItems(animated: Bool = false) {
        for indexPath in self.indexPathsForSelectedItems ?? [] {
            self.deselectItem(at: indexPath, animated: animated)
        }
    }
}





















