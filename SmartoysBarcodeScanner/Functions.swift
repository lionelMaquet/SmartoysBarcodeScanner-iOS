//
//  Functions.swift
//  SmartoysBarcodeScanner
//
//  Created by Lionel Maquet on 05/08/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import Foundation
import SafariServices
import BarcodeScanner
import SwiftSoup




func setupDelegateAndPresentBarcodeScanner(barcodeVCDelegate: ViewController) -> BarcodeScannerViewController {
    let viewController = BarcodeScannerViewController()
    viewController.modalPresentationStyle = .overFullScreen
    viewController.codeDelegate = barcodeVCDelegate
    viewController.errorDelegate = barcodeVCDelegate
    viewController.dismissalDelegate = barcodeVCDelegate
    
    
    barcodeVCDelegate.present(viewController, animated: true, completion: nil)
    return viewController
    
    
}

func openURLInSafari(url: String, safariVCDelegate: ViewController ) {
    let goalURL = URL(string: url)
    var safariVC = SFSafariViewController(url: goalURL!)
    safariVC.modalPresentationStyle = .fullScreen
    safariVCDelegate.present(safariVC, animated: true, completion: nil)
}

func getProductInfos(urlString: String) -> [String:String]{
    
    let myURL = URL(string: urlString)

    do {
        let myHTMLString = try String(contentsOf: myURL!, encoding: .ascii)
        let doc : Document = try SwiftSoup.parse(myHTMLString)
        let productName = try doc.select("h1#productName").first()
        let paragraphTags : Elements = try doc.select("p")
        let tagsWithProductPriceClass = try doc.select("p.product-price")
        if (tagsWithProductPriceClass.count > 1){
            let mainPriceElement = try doc.select("p.product-price").first()
            let occasionPriceElement = try doc.select("p.product-price")[1]
            
            return ["nom_produit": try productName!.text(),
                "prix_neuf": try mainPriceElement!.text(),
                    "prix_occasion": try occasionPriceElement.text()]
        }
        
    
        
    } catch let error {
        print("Error: \(error)")
    }
    
    return [:]
    
}
