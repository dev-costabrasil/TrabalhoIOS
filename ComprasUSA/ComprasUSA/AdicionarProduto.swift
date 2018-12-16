//
//  AdicionarProduto.swift
//  ComprasUSA
//
//  Created by Rafael Dias on 15/12/18.
//  Copyright © 2018 Rafael Dias. All rights reserved.
//

import UIKit

class AdicionarProduto: UIViewController {
    
    @IBOutlet private weak var textFieldNameProduct: UITextField!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textFieldState: UITextField!
    @IBOutlet private weak var textFieldPrice: UITextField!
    @IBOutlet private weak var switchCard: UISwitch!
    @IBOutlet private weak var buttonRegister: UIButton!
    @IBOutlet weak var buttoPhoto: UIButton!
    
    var product: Produto!
    lazy var pickerView : UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    var stateManager = Estados.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if product != nil {
            title = "Editar produto"
            buttonRegister.setTitle("Alterar", for: .normal)
            if product.imagem != nil {
                buttoPhoto.setTitle(nil, for: .normal)
            }
            textFieldNameProduct.text = product.nome
            textFieldState.text = product.produtoxestado?.description
            if let image = product.imagem as? UIImage {
                imageView.image = image
            } else {
                debugPrint("Sem imagem!")
            }
            textFieldPrice.text = product.preco.description
            textFieldState.text = product.produtoxestado?.nome
            switchCard.isOn = product.cartao
            
        }
        
        prepareProductTextField()
        
    }
    
    func prepareProductTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done ))
        let btFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btCancel, btFlexibleSpace, btDone]
        textFieldState.inputView = pickerView
        textFieldState.inputAccessoryView = toolbar
    }
    
    
    @objc func cancel() {
        textFieldState.resignFirstResponder()
    }
    
    @objc func done() {
        
        textFieldState.text = stateManager.estados[pickerView.selectedRow(inComponent: 0)].nome
        
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stateManager.buscar(with: context)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPhotoProduct(_ sender: Any) {
        let alert = UIAlertController(title: "Selecione imagem", message: "Buscar imagem de onde?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        let libaryAction = UIAlertAction(title: "Biblioteca", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libaryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func addEditProduct(_ sender: UIButton) {
        
        guard let nome = textFieldNameProduct.text, let txtPrice = textFieldPrice.text, let price = Double(txtPrice),let image = imageView.image, !nome.isEmpty, !txtPrice.isEmpty
            else {validate(); return}
        
        if product == nil {
            product = Produto(context: context)
        }
        product.nome = textFieldNameProduct.text
        product.imagem = image
        product.preco = price
        product.cartao = switchCard.isOn
        if !textFieldState.text!.isEmpty {
            let states = stateManager.estados[pickerView.selectedRow(inComponent: 0)]
            states.addToState_product(product)

            
        }
        product.imagem = imageView.image
        do{
            try context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func validate() {
        let alert = UIAlertController(title: "Aviso!", message: "Todos os campos são obrigatórios", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension AdicionarProduto : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateManager.estados.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let state = stateManager.estados[row]
        return state.nome
    }
    
}

/*
extension AdicionarProduto : UIImagePickerControllerDelegate, UINavigationControllerDelegate
 {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
      
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
    
            let aspectRatio = image.size.width / image.size.height
            let maxSize: CGFloat = 500
            var smallSize: CGSize
            if aspectRatio > 1 {
                smallSize = CGSize(width: maxSize, height: maxSize/aspectRatio)
            } else {
                smallSize = CGSize(width: maxSize*aspectRatio, height: maxSize)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }


        buttoPhoto.setTitle("", for: .normal)
        
        dismiss(animated: true, completion: nil)
    }

}
 */

