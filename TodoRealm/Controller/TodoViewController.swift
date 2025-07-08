import UIKit
import CoreData
class TodoViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory: Category?{
        // what should happen when a variable gets set with a new value 
        // everything in didsSet would be executed once selectedCategory gets a value
        didSet{
            loaddata()
        }
    }

    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.delegate=self


    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
  
        let item = itemArray[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        
        cell.contentConfiguration = content
        
        cell.accessoryType = item.done ? .checkmark : .none
     
        return cell
    }
    
    // this method is triggered whrn user selecdts a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Code to respond to selection
         
//context.delete(itemArray[indexPath.row])
//itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !(itemArray[indexPath.row].done)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)// first gray then gack to previous color
        
        
    
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo Item ", message: "", preferredStyle: .alert)
        
        // triggered when add item in  alert is pressed
        let action = UIAlertAction(title: "Add  Item", style: .default) { (action) in
            // what will happen when user clicjks the add new item button on ui alert
            
            // item was added in arrasy but not displayed in table view
            

            
            let newItem = Item(context: self.context)
            newItem.title=textField.text!
            newItem.done=false
            newItem.parentCategory=self.selectedCategory
            self.itemArray.append(newItem)
          
            self.saveItems()
        }
        // triggererd when alert appears on screen
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item ..."
            textField=alertTextField
          }
        alert.addAction(action)
        self.present(alert, animated: true)
        
    }
    
    func saveItems(){
        do{
           try  context.save()
        }catch{
            print(error)
        }
        self.tableView.reloadData()
        
    }
    func loaddata(request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
      

        let categoryPredicate = NSPredicate(format:"parentCategory == %@", selectedCategory!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error")
        }

        tableView.reloadData()
    }

}



extension  TodoViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text! )
        let sortDescriptor = NSSortDescriptor(key: "title" , ascending: true)
        request.sortDescriptors=[sortDescriptor]
        loaddata(request: request,predicate: predicate)
   
        
    }
    // when text change and it has gone 0
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count  == 0{
            loaddata()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()// no longer there should be cursoe and remove keyboard
            }
        }
    }
}
