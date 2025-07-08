//
//  CategoryViewController.swift
//  Todo
//
//  Created by Lakshaya Singh Tanwar on 07/07/25.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loaddata()

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
  
        let category = categoryArray[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = category.name
        
        cell.contentConfiguration = content
        
        return cell
    }

  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo Category ", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add  Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name=textField.text!
            self.categoryArray.append(newCategory)
          
            self.saveCategory()
        }
        // triggererd when alert appears on screen
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category ..."
            textField=alertTextField
          }
        alert.addAction(action)
        self.present(alert, animated: true)
        
    }
    func saveCategory(){
        do{
           try  context.save()
        }catch{
            print(error)
        }
        self.tableView.reloadData()
        
    }
    func loaddata( request : NSFetchRequest<Category> = Category.fetchRequest()){
       
        do{
           categoryArray = try context.fetch(request)
        }
        catch{
            print(error)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    // just before the segue is performed this method is triggered
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        // identify the currenrt row that is selected
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
}
