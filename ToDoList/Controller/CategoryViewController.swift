//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Tao Wen on 2019-02-16.
//  Copyright © 2019 Tao Wen. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFiled = UITextField()
        
        let alert = UIAlertController(title: "Add New Catergory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Catergory", style: .default) { (action) in
            if let newCategoryName = textFiled.text {
                
                let newCategory = Category(context: self.context)
                newCategory.name = newCategoryName
                
                self.categoryArray.append(newCategory)
                
                self.saveCategory()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "catergory name"
            textFiled = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TaleVeiw DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
        
    }
    
    func saveCategory() {
        do{
            try self.context.save()
        }catch{
            print("Eror saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray =  try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    //MARK: - TableVeiw Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}
