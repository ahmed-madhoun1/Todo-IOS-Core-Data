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
    
}

