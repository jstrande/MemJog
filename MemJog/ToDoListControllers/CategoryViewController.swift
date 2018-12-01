//
//  CategoryViewController.swift
//  MemJog
//
//  Created by Jon Strande on 11/29/18.
//  Copyright © 2018 Jon Strande. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit


class CategoryViewController: UITableViewController {

    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate) .persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories();
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
     }
 
     */
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        let category = categoryArray[indexPath.row];
        cell.textLabel?.text = category.name;
        cell.accessoryType = .disclosureIndicator;
        
        cell.delegate = self;
        
        return cell;
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //this would be what would happen if I touch an item
        //to go to the detail screen to see the list
        performSegue(withIdentifier: "goToItems", sender: self)
        
        //give it better animation
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(segue.identifier!)
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
        
    }
    
    //MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert);
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context);
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
        }
        alert.addTextField(configurationHandler: { (alertTextField) in alertTextField.placeholder = "Add New Category"
            textField = alertTextField;
            
            })
        alert.addAction(action)
        present(alert, animated: true, completion: nil);
        
    }

    
    //MARK: - Data Manipulation Methods
    func saveCategory () {
        do {
            try context.save();
        }
        catch {
            print("inside catch of saveCategory(), \(error)")
        }
        self.tableView.reloadData();
    }
    func loadCategories () {
        do {
            let request : NSFetchRequest<Category> = Category.fetchRequest();
            categoryArray = try context.fetch(request);
        }
        catch {
            print("Error loading categories when fetching \(error)");
        }
        tableView.reloadData();
    }
    
}

//MARK: - SwipeTableViewCellDelegate extension
extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item Deleted")
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash Icon")
        
        return [deleteAction]
    }
    
}
