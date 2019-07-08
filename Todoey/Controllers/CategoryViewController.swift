//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Samuel Johnson on 24/06/2019.
//  Copyright © 2019 Samuel Johnson. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
//    let config = Realm.Configuration(schemaVersion: 1)

    let realm = try! Realm()

    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadCategories()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colourHex) else {fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        
        }
        
        return cell
            
    }
        
    
    //MARK: - Data Manipulation Methods

    func save(category: Category) {

        do {
            try realm.write {
                realm.add(category)
            }        } catch {
            print("Error saving category \(error)")
        }

        self.tableView.reloadData()

    }

    func loadCategories() {

        categories = realm.objects(Category.self)

        tableView.reloadData()

    }
    
    //MARK: - delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting Category \(error)")
            }

        }
    }
    
    
        //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colourHex = RandomFlatColor().hexValue()

            self.save(category: newCategory)
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
        }
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
        
    }

    
   
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
}


    


