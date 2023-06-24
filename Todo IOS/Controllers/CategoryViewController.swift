//
//  CategoryViewController.swift
//  Todo IOS
//
//  Created by Ahmed Madhoun on 24/06/2023.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var list = [CategoryEntity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for:   indexPath)
        let category = list[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodos", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.category = list[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
 
    func saveCategory(){
        do{
            try context.save()
        }catch {
            print(error)
        }
    }
    
    func loadData(with request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()){
        do{
            list = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    // MARK: - Add category alert
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default){(action) in
            if textField.text != nil && !textField.text!.isEmpty {
                let newCategory = CategoryEntity(context: self.context)
                newCategory.name = textField.text
                self.list.append(newCategory)
                self.saveCategory()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
