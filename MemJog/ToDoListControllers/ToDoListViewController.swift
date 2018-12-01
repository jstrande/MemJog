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
    var selectedCategory : Category? {
        didSet {
            loadItems();
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask);
        //print(dataFilePath);
        
        //loadItems();
        let navigationTitle = selectedCategory?.name;
        if navigationTitle != nil {
            navigationItem.title = navigationTitle;
        }
        else {
            navigationItem.title = "Reminders";
        }
        
    }

    //MARk: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row];
        cell.textLabel?.text = item.title;
    
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
            
            //this is what happens when the person clicks the add item alert thing
            let newItemX = Item(context: self.context);
            newItemX.title = textField.text!
            newItemX.done = false;
            newItemX.parentCategory = self.selectedCategory;
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
            print("inside catch of saveItems(), \(error)")
        }
        self.tableView.reloadData();
    }
    
    //MARK: - LOAD ITEMS
 
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //print("printing request")
        //print(request)
       
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate;
        }
        
        /*
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        request.predicate = compoundPredicate;
         */
        
        do {
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error loading items when fetching \(error)");
        }
        tableView.reloadData();
    }

    
}

//MARK: - SEARCH BAR METHODS
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest();
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)];
        
        loadItems(with: request, predicate: predicate);

        
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

