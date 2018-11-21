//
//  ViewController.swift
//  MemJog
//
//  Created by Jon Strande on 11/20/18.
//  Copyright © 2018 Jon Strande. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    //var itemArray = ["Clean House", "Learn Swift", "Book Flight", "Cook Tacos"]
    var itemArray = [ToDoItem]()
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = ToDoItem()
        newItem.toDoItemTitle = "Clean the house";
        newItem.isDone = false
        itemArray.append(newItem);
        
        let newItem2 = ToDoItem()
        newItem2.toDoItemTitle = "Learn Swift";
        newItem2.isDone = true;
        itemArray.append(newItem2);
        
        let newItem3 = ToDoItem()
        newItem3.toDoItemTitle = "Book Flight";
        newItem3.isDone = false
        itemArray.append(newItem3);
        
        if let items = defaults.array(forKey: "ToDoList") as? [ToDoItem] {
            itemArray = items;
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row];
        cell.textLabel?.text = item.toDoItemTitle;
       
        //THIS ONE LINE
        //cell.accessoryType = item.isDone == true ? .checkmark : .none;
        
        //REPLACES THESE LINES
        if item.isDone == true {
            cell.accessoryType = .checkmark;
        }
        else {
            cell.accessoryType = .none;
        }
        
        return cell;
    }
    
    //MARK -- Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone;
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true);
    }
    //override func tabl

    //MARK -- Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            print("CREATING NEW ITEM")
            //what happens when the person clicks the add item alert thing
            let newItemX = ToDoItem();
            newItemX.toDoItemTitle = textField.text!
            print("NEW ITEM CREATED: " + newItemX.toDoItemTitle);
            
            print("APPENDING TO ARRAY")
            self.itemArray.append(newItemX)
            print("SETTING INTO DEFAULS")
            
            /******************************************
             //
             // I have a bug here - it crashes when I set this 
             //
             //
 
            */
            
            
            self.defaults.set(self.itemArray, forKey: "ToDoList");
            print("RELOADING TABLE VIEW")
            self.tableView.reloadData();
            
        }
        alert.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField;
            
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func addItem () {
        //once this works, refactor things...
    }
    
}

