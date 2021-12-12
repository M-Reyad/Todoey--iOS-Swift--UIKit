//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var toDoListArray = [ItemData]()

    let dataFileLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(K.ItemsPlist)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decoder()
    }
    
    //MARK:- New Item Button
    @IBAction func newItemButtonPressed(_ sender: UIBarButtonItem) {
        let newItem = ItemData()
        var newItemTextField = UITextField()

        let alert = UIAlertController(title: "Add New Item", message: "Add New Item", preferredStyle: .alert)

                alert.addTextField { (alertTextField) in
                    alertTextField.placeholder = "Type New Item"

                    newItemTextField = alertTextField

                    print(newItemTextField.text ?? "")
                }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let addItemAction = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if newItemTextField.text == "" {
                let errorAlert = UIAlertController(title: "Error!", message: "Add Something!!", preferredStyle: .alert)
                let errorAction = UIAlertAction(title: "OK", style: .default) {(action) in
                    self.present(alert, animated: true)
                }

                errorAlert.addAction(errorAction)
                self.present(errorAlert, animated: true)
            } else {
                newItem.title = newItemTextField.text!

                self.toDoListArray.append(newItem)
                self.encoder()

                
             
        }

                }
        alert.addAction(addItemAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = toDoListArray[indexPath.row].title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }

}

//MARK:- Encoder and Decoder Function
extension TodoListViewController {
    func encoder(){
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(self.toDoListArray)
                try data.write(to: self.dataFileLocation!)
        }catch{
                print("error! \(error)" )
        
    }
        self.tableView.reloadData()
    }
    
    func decoder (){
        let decoder = PropertyListDecoder()
        var data = Data()
        do{
        if let safeData = try? Data(contentsOf: self.dataFileLocation!) {
            data = safeData
            }
            self.toDoListArray = try decoder.decode([ItemData].self, from: data)
        } catch{
            print("Cannot decode Data from the Property List \(error)")
        }
        
    }

}
