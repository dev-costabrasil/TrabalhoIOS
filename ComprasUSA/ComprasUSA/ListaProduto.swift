//
//  ListaProduto.swift
//  ComprasUSA
//
//  Created by Rafael Dias on 15/12/18.
//  Copyright © 2018 Rafael Dias. All rights reserved.
//

import UIKit
import CoreData

class ListaProduto: UITableViewController {
    
    var fetchedResultController: NSFetchedResultsController<Produto>!
    var labelEmpity = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelEmpity.text = "Sua lista está vazia!"
        labelEmpity.textAlignment = .center
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listarprodutos()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newProductSegue" {
            _ = segue.destination as! AdicionarProduto
            
        } else {
            let vc = segue.destination as! AdicionarProduto
            if let produto = fetchedResultController.fetchedObjects {
                vc.product = produto[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func listarprodutos() {
        let fetchRequest: NSFetchRequest<Produto> = Produto.fetchRequest()
        let sortDescritor = NSSortDescriptor(key: "nome", ascending: true)
        fetchRequest.sortDescriptors = [sortDescritor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = fetchedResultController.fetchedObjects?.count ?? 0
        
        tableView.backgroundView = count == 0 ? labelEmpity : nil
        
        if count == 0 {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
        }
        
        return count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CelulaProduto
        
        guard let product = fetchedResultController.fetchedObjects?[indexPath.row] else {
            return cell
        }
        
        cell.prepare(with: product)
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductRegister") as! AdicionarProduto
        
        vc.product = fetchedResultController.object(at: indexPath)
        
        navigationController?.pushViewController(vc, animated: true)
        
    }


    
}

extension ListaProduto: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        default:
            tableView.reloadData()
        }
    }
}

