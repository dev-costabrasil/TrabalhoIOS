//
//  Estados.swift
//  ComprasUSA
//
//  Created by Rafael Dias on 15/12/18.
//  Copyright © 2018 Rafael Dias. All rights reserved.
//

import CoreData

class Estados {
    
    static let shared = Estados()
    var estados : [Estado] = []
    
    func buscar(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Estado> = Estado.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            estados = try context.fetch(fetchRequest)
        } catch  {
            debugPrint(error.localizedDescription)
        }
    }
    
    func apagar(index: Int, context: NSManagedObjectContext){
        let estado = estados[index]
        context.delete(estado)
        do {
            try context.save()
            estados.remove(at: index)
        } catch  {
            debugPrint(error.localizedDescription)
        }
    }
    
    private init() {
        
    }
}

