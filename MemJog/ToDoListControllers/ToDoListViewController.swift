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
    
    //Note, the file name here - can have multiple plist files...
    //one plist for each category of to do items
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("MemJogItems.plist");
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(dataFilePath!);
        /*
        // dataFilePath =
        //Users/jonstrande/Library/Developer/CoreSimulator/Devices/38DEC7D1-3B2B-4192-9EA3-BA083281EBCD/data/Containers/Data/Application/F46BCBD7-A047-4F8B-8F3A-D046673B6E3B/Documents/
         */

        loadItems();
        
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
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true);
    }
    //override func tabl

    //MARK -- Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            //this is what happens when the person clicks the add item alert thing
            let newItemX = ToDoItem();
            newItemX.toDoItemTitle = textField.text!

            self.itemArray.append(newItemX)
            self.saveItems()
            
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
    
    //MARK -- SAVE ITMEMS
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray);
            try data.write(to: dataFilePath!);
        }
        catch {
            print("inside catch of encoder.encode, \(error)")
        }
        self.tableView.reloadData();
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let myDecoder =  PropertyListDecoder()
            do {
                itemArray = try myDecoder.decode([ToDoItem].self, from: data);
            }
            catch {
                print("error decoding items from itemARray \(error)");
            }
        }
    }
    
}

