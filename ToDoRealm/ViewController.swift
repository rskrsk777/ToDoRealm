
import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var table: UITableView!
    private var items: Results<ToDoItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        setupNav()
        setupTableView()
        items = ToDoItem.all()
    }
    
    func setupNav () {
        self.navigationItem.title = "ToDoItem"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = UIColor.cyan
        //self.navigationItem.setLeftBarButton(leftNavButton, animated: true)
        self.navigationItem.setLeftBarButton(editButtonItem, animated: true)
        let rightNavButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlert))
        self.navigationItem.setRightBarButton(rightNavButton, animated: true)

    }
    
    func setupTableView () {
        self.table = {
            let table = UITableView(frame: UIScreen.main.bounds)
            table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            table.dataSource = self
            table.delegate = self
            view.addSubview(table)
            return table
        }()
        
    }
    
    @objc func showAlert () {
        let alert = UIAlertController(title: "Add ToDoItem", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .alphabet
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                return
            }
            ToDoItem.add(text: text)
            self.table.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteItem (_ item: ToDoItem) {
        item.delete()
    }
    
    
    

}

extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.detailTextLabel?.text = (items?[indexPath.row].isCompeleted)! ? "Completed" : "Not Compeleted"
        cell.textLabel?.text = items?[indexPath.row].text
        cell.textLabel?.attributedText = NSAttributedString(string: cell.textLabel!.text!, attributes: (items?[indexPath.row].isCompeleted)! ? [NSAttributedString.Key.strikethroughStyle: true] : [:])
        return cell
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let item = items?[indexPath.row], editingStyle == .delete else {
            return
        }
        deleteItem(item)
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt \(indexPath)")
        ToDoItem.toggleIsCompleted((items?[indexPath.row])!)
        table.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.table.isEditing = editing
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


