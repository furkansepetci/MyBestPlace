//
//  TableViewController.swift
//  MyBestPlace
//
//  Created by Furkan Sepetci on 8.08.2022.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var nameArray = [String]()
    var idArray = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        getData()
    }
    
    @IBAction func unwindSegue(_ sender:UIStoryboardSegue){}
    
    func getData () {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BestPlace")
        request.returnsObjectsAsFaults = false
        
        do{
            let objects = try context.fetch(request)
            
            if objects.count > 0 {
                
                self.nameArray.removeAll(keepingCapacity: false)
                self.idArray.removeAll(keepingCapacity: false)
                
                for object in objects as! [NSManagedObject]{
                    
                    if let name = object.value(forKey: "name") as? String {
                        self.nameArray.append(name)
                    }
                    if let idNumber = object.value(forKey: "id") as? UUID {
                        self.idArray.append(idNumber)
                    }
                    
                    myTableView.reloadData()                }
            }
        } catch {
            
            print("Error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "BestPlace")
            
            let idNumber = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idNumber)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                        let objects = try context.fetch(fetchRequest)
                            if objects.count > 0 {
                                
                                for object in objects as! [NSManagedObject] {
                                    
                                    if let id = object.value(forKey: "id") as? UUID {
                                        
                                        if id == idArray[indexPath.row] {
                                            context.delete(object)
                                            nameArray.remove(at: indexPath.row)
                                            idArray.remove(at: indexPath.row)
                                            self.myTableView.reloadData()
                                            
                                            do {
                                                try context.save()
                                                
                                            } catch {
                                                print("error")
                                            }
                                            
                                            break
                                            
                                        }
                                        
                                    }
                                    
                                    
                                }
                                
                                
                            }
                        } catch {
                            print("error")
                        }
        }
    }
    
    @objc func addButtonClicked () {
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
}
