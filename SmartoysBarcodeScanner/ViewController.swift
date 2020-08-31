//
//  ViewController.swift
//  SmartoysBarcodeScanner
//
//  Created by Lionel Maquet on 05/08/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import UIKit
import BarcodeScanner
import SafariServices
import SwiftSoup



class ViewController: UIViewController {
    
    var senderIsOn = true
    
    func addSwitchToBarcodeVC(barcodeVC: BarcodeScannerViewController){
        let switchDemo=UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        switchDemo.addTarget(self, action: #selector(ViewController.switchStateDidChange(_:)), for: .valueChanged)
        switchDemo.setOn(true, animated: false)
        barcodeVC.view.addSubview(switchDemo)
    }
    
    
    
    var alert = UIAlertController()
    
    @objc func switchStateDidChange(_ sender:UISwitch)
    {
        senderIsOn = sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        let vc = setupDelegateAndPresentBarcodeScanner(barcodeVCDelegate: self)
        addSwitchToBarcodeVC(barcodeVC: vc)
        
        
        
    }
}

extension ViewController:BarcodeScannerCodeDelegate {
    typealias alertMethod = () -> Void
    
    func showAlertMessage(title:String? = nil, _ message:String, action: @escaping alertMethod) {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            action()
        }

        // Add the actions
        alert.addAction(okAction)
        
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController  {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(self.alert, animated: true, completion: nil)
            
        }}
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        let productURLString = "https://www.smartoys.be/catalog/product_info.php?products_id=\(code)"
        
        
        
        if (senderIsOn){
            controller.dismiss(animated: false, completion: {

                openURLInSafari(url:productURLString, safariVCDelegate: self  )


            })
            
        } else {
            let productInfos = getProductInfos(urlString: productURLString)
            let productName = productInfos["nom_produit"]
            let productMainPrice = productInfos["prix_neuf"]
            let productOccasionPrice = productInfos["prix_occasion"]
            
            self.showAlertMessage(title: "\(productName!)", " prix neuf : \(productMainPrice!) \n\n prix d'occasion : \(productOccasionPrice!)") {
                controller.reset(animated: false)
            }
        }
        

        
        
        
        
        
        
        
        
        
    }
}

extension ViewController:BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        
    }
}

extension ViewController:BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    }
}

