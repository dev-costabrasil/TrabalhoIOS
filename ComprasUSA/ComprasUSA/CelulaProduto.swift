//
//  CelulaProduto.swift
//  ComprasUSA
//
//  Created by Rafael Dias on 15/12/18.
//  Copyright © 2018 Rafael Dias. All rights reserved.
//

import UIKit

class CelulaProduto: UITableViewCell {
    
    @IBOutlet private weak var imageViewProduct: UIImageView!
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func prepare(with produto: Produto) {
        labelName.text = produto.nome ?? ""
        labelPrice.text = String(produto.preco) ?? "0"
        if let image = produto.imagem as? UIImage {
            imageViewProduct.image = image
        } else {
            imageViewProduct.image = UIImage(named: "vazio")
        }
    }
    
}
