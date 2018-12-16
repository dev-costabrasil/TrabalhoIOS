//
//  ECore.swift
//  ComprasUSA
//
//  Created by Rafael Dias on 15/12/18.
//  Copyright © 2018 Rafael Dias. All rights reserved.
//

import Foundation
import CoreData

extension Estados {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Estado> {
        return NSFetchRequest<Estado>(entityName: "Estados")
    }
    
    @NSManaged public var nome: String?
    @NSManaged public var taxa: Double
    @NSManaged public var estadoxproduto: NSSet?
    
}

extension Estados {
    
    @objc(addState_productObject:)
    @NSManaged public func addToState_product(_ value: Produto)
    
    @objc(removeState_productObject:)
    @NSManaged public func removeFromState_product(_ value: Produto)
    
    @objc(addState_product:)
    @NSManaged public func addToState_product(_ values: NSSet)
    
    @objc(removeState_product:)
    @NSManaged public func removeFromState_product(_ values: NSSet)
    
}
