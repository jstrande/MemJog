//
//  ViewController.swift
//  MemJog
//
//  Created by Jon Strande on 11/20/18.
//  Copyright © 2018 Jon Strande. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    //var itemArray = ["Clean House", "Learn Swift", "Book Flight", "Cook Tacos"]
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    //Note, the file name here - can have multiple plist files...
    //one plist for each category of to do items
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("MemJogItems.plist");
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask);
        
        print(dataFilePath);
        
        loadItems();
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row];
        cell.textLabel?.text = item.title;
       
        
        //THIS ONE LINE
        //cell.accessoryType = item.isDone == true ? .checkmark : .none;
        
        //REPLACES THESE LINES
        if item.done == true {
            cell.accessoryType = .checkmark;
        }
        else {
            cell.accessoryType = .none;
        }
        
        return cell;
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //These methods here remove the items.
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done;
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true);
    }
    //override func tabl

    //MARK: - ADD NEW ITEMS
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
            //this is what happens when the person clicks the add item alert thing
            let newItemX = Item(context: self.context);
            newItemX.title = textField.text!
            newItemX.done = false;

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
    
    //MARK: - SAVE ITMEMS
    
    func saveItems () {
        //let encoder = PropertyListEncoder()
        do {
            //let data = try encoder.encode(itemArray);
            //try data.write(to: dataFilePath!);
            try context.save();
        }
        catch {
            print("inside catch of encoder.encode, \(error)")
        }
        self.tableView.reloadData();
    }
    
    //MARK: - LOAD ITEMS
 
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        //print("printing request")
        //print(request)
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error loading items when fetching \(error)");
        }
        tableView.reloadData();
    }
    /*
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error loading items when fetching \(error)");
        }
        tableView.reloadData();
    }
    */
    


    
}

//MARK: - SEARCH BAR METHODS
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest();
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)];

        loadItems(with: request);

        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems();
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

