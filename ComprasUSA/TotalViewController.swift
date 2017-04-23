//
//  TotalViewController.swift
//  ComprasUSA
//
//  Created by Ricardo Tourinho on 23/04/17.
//  Copyright © 2017 Ricardo Tourinho. All rights reserved.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {
    
    @IBOutlet weak var totalReais: UILabel!
    @IBOutlet weak var totalDollar: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calculate()
    }
    
    func calculate() {
        let iof: Double = UserDefaults.standard.double(forKey: "iof")
        let dollar: Double  = UserDefaults.standard.double(forKey: "cotacaoDollar")
        var dataSource: [Product] = []
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        
        var tDollar = 0.0
        var tReais = 0.0
        for product in dataSource {
            let tax = product.state?.tax
            let priceWithTaxes = product.price + product.price * tax!/100
            tDollar = tDollar + priceWithTaxes
            var priceInReal = priceWithTaxes * dollar
            if product.creditcard {
                priceInReal = priceInReal + priceInReal * iof/100
            }
            tReais = tReais + priceInReal
        }
        
        //let tDollar: Double = dataSource.reduce(0, {($0 + ($1.price * (1.0 + ($1.state?.tax)!)) + ($1.creditcard ? $1.price * (1.0 + ($1.state?.tax)!) * iof : 0.0))})
        totalDollar.text = "\(tDollar)"
        totalReais.text = "\(tReais)"
    }

}
