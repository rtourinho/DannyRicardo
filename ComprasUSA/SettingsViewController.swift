//
//  SettingsViewController.swift
//  ComprasUSA
//
//  Created by Ricardo Tourinho on 23/04/17.
//  Copyright © 2017 Ricardo Tourinho. All rights reserved.
//

import UIKit
import CoreData

enum StateAlertType {
    case add
    case edit
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tvCotacaoDolar: UITextField!
    @IBOutlet weak var tvIOF: UITextField!
    
    var dataSource: [State] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tvCotacaoDolar.text = UserDefaults.standard.string(forKey: "cotacaoDollar")
        tvIOF.text = UserDefaults.standard.string(forKey: "iof")
    }
    
    @IBAction func addState(_ sender: UIButton) {
        showAlert(type: .add, state: nil)
    }

    @IBAction func updateDollar(_ sender: UITextField) {
        UserDefaults.standard.set(tvCotacaoDolar.text, forKey: "cotacaoDollar")
    }

    
    @IBAction func updateIOF(_ sender: UITextField) {
        UserDefaults.standard.set(tvIOF.text, forKey: "iof")
    }

    
    func loadStates() {
        tableView.delegate = self
        tableView.dataSource = self
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(type: StateAlertType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estados", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
            if let tax = state?.tax {
                textField.text = "\(tax)"
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let state = state ?? State(context: self.context)
            if let name = alert.textFields?.first?.text {
                state.name = name
            } else {
                //erro
            }
            if let tax = Double((alert.textFields?.last?.text)!) {
                state.tax = tax
            } else {
                //erro
            }
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAlert(type: .edit, state: dataSource[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row].name
        cell.detailTextLabel?.text = "\(dataSource[indexPath.row].tax)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            self.context.delete(state)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [deleteAction]
    }
}
