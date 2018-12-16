//
//  TotalGeral.swift
//  ComprasUSA
//
//  Created by Rafael Dias on 15/12/18.
//  Copyright © 2018 Rafael Dias. All rights reserved.
//

import UIKit
import CoreData

class TotalGeral: UIViewController {
    
    @IBOutlet private weak var labelTotalDolar: UILabel!
    @IBOutlet private weak var labelTotalReal: UILabel!
    var fetchedResultController: NSFetchedResultsController<Produto>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateValues()
    }
    
    func loadProducts() {
        let fetchRequest: NSFetchRequest<Produto> = Produto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateValues() {
        guard let products = fetchedResultController.fetchedObjects,
            let dolar = UserDefaults.standard.value(forKey: "dolar") as? Double,
            let iof = UserDefaults.standard.value(forKey: "iof") as? Double
            else {return}
        
        var totalDolar = 0.0
        var totalReal = 0.0
        
        for produto in products {
            totalDolar += produto.preco + produto.produtoxestado!.taxa
            
            if produto.cartao {
                totalReal += ((produto.preco + produto.produtoxestado!.taxa) * dolar) * ((iof / 100) + 1)
            }
            else {
                totalReal += (produto.preco + produto.produtoxestado!.taxa) * dolar
            }
        }
        
        labelTotalReal.text = String(format: "R$ %.2f", totalReal)
        labelTotalDolar.text = String(format: "U$ %.2f", totalDolar)
    }
}

extension TotalGeral: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateValues()
    }
}
