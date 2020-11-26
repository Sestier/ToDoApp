//
//  ViewController.swift
//  ToDoApp
//
//  Created by mawetecnologías on 22/11/20.
//  Copyright © 2020 sestier. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //Item from model.
    var itemArray = [Item]()
    
    //To save something in coredata
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Values to pass
    var cTitle:String!
    var cContent:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //puntero que le dice al viewcontroller que cuando guarde información haga el refresh
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name(rawValue: "Notification"), object: nil)
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }
    
    @objc func refresh() {
        loadItems()
        tableView.reloadData()
    }
    
    //MARK - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if itemArray.count == 0 {
        tableView.setEmptyView(title: "You don't have any notifications.", message: "We will send you a notification when necessary.")
        }
        else {
        tableView.restore()
        }

        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    //MARK - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Animation to get better UX at selecting a row
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = itemArray[indexPath.row]
        cTitle = item.title
        cContent = item.content
        
        performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToDetail") {
            let destination = segue.destination as? DetailViewController
            destination?.cTitle = cTitle
            destination?.cContent = cContent
        }
    }
    
    //MARK - Delete all items button
    @IBAction func btnDeleteList(_ sender: Any) {
        let alert = UIAlertController(title: "Clear", message: "This action will clear the list.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteItems()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func deleteItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            for item in results {
                //guard let itemData = item as? NSManagedObject else {continue}
                context.delete(item)
                itemArray.removeAll()
                tableView.reloadData()
            }
        
        } catch {
            print("Error deleting data from context \(error)")
        }
    }
    
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        //Setting tableView to empty.
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

