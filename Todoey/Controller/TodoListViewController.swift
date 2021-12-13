//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    var toDoListArray = [ItemData]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

/*
-- Used only in Plist model, replaced by CoreData DataBase!! --
     let dataFileLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(K.ItemsPlist)
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContext()
    }
    
    //MARK:- New Item Button
    @IBAction func newItemButtonPressed(_ sender: UIBarButtonItem) {
        
        let newItem = ItemData(context: context)
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
                newItem.done = false
                self.toDoListArray.append(newItem)
                self.saveContext()

                
             
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

//MARK:- Save and Read Context Functions
extension TodoListViewController {
    func saveContext(){
            do {
                try context.save()
        }catch{
                print("error! \(error)" )
    }
        self.tableView.reloadData()
    }
    
    func loadContext (){
//        let decoder = PropertyListDecoder()
        let request : NSFetchRequest<ItemData> = ItemData.fetchRequest()
        do{ try toDoListArray = context.fetch(request)
            }catch{
            print("Cannot decode Data from the DataBase \(error)")
        }

    }

}
