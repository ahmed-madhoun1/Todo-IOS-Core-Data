//
//  ViewController.swift
//  Todo IOS
//
//  Created by Ahmed Madhoun on 17/06/2023.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var list = [TodoEntity]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for:   indexPath)
        let todo = list[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.accessoryType = todo.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        list[indexPath.row].done = !list[indexPath.row].done
        self.saveTodo()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new todo"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default){(action) in
            if let text = textField.text {
                let newTodo = TodoEntity(context: self.context)
                newTodo.title = text
                newTodo.done = false
                self.list.append(newTodo)
                self.saveTodo()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveTodo(){
        do{
            try context.save()
        }catch {
            print(error)
        }
    }
    
    func loadData(with request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()){
        do{
            list = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
}

// MARK: - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text != nil && searchBar.text!.count > 0){
            let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadData(with: request)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
