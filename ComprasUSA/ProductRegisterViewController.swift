//
//  ProductRegisterViewController.swift
//  ComprasUSA
//
//  Created by Ricardo Tourinho on 16/04/17.
//  Copyright © 2017 Ricardo Tourinho. All rights reserved.
//

import UIKit
import CoreData

class ProductRegisterViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivPicture: UIImageView!
    @IBOutlet weak var swCreditCard: UISwitch!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var btAddUpdate: UIButton!
    
    var states: [State]! = []
    var product: Product!
    
    var stateSelected: State!
    
    var smallImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStatePicker()
        loadProduct()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (product != nil) {
            stateSelected = product.state
            btAddUpdate.setTitle("ATUALIZAR", for: .normal)
        }
    }
    
    @IBAction func loadPicture(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar produto", message: "De onde você quer escolher a Foto?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)

    }
    
    @IBAction func addOrUpdateProduct(_ sender: UIButton) {
        if product == nil {
            product = Product(context: context)
        }
        product.name = tfName.text
        if let price: Double = Double(tfPrice.text!) {
            product.price = price
        } else {
            product.price = 0
        }
        product.creditcard = swCreditCard.isOn
        product.picture = ivPicture.image
        product.state = stateSelected
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            states = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadStatePicker() {
        loadStates()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        tfState.inputView = pickerView
    }
    
    func loadProduct() {
        if product != nil {
            tfName.text = product.name
            if let image = product.picture as? UIImage {
                ivPicture.image = image
            }
            swCreditCard.setOn(product.creditcard, animated: true)
            tfPrice.text = "\(product.price)"
            tfState.text = product.state?.name
        }
    }
}

extension ProductRegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfState.text = states[row].name
        stateSelected = states[row]
        self.view.endEditing(true)
    }
}

extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let smallSize = CGSize(width: 300, height: 280)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        ivPicture.image = smallImage
        dismiss(animated: true, completion: nil)
    }
}
