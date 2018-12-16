//
//  VCore.swift
//  ComprasUSA
//
//  Created by Rafael Dias on 15/12/18.
//  Copyright © 2018 Rafael Dias. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
