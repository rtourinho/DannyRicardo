//
//  UIViewController+CoreData.swift
//  ComprasUSA
//
//  Created by Ricardo Tourinho on 16/04/17.
//  Copyright © 2017 Ricardo Tourinho. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
