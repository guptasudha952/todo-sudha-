//
//  ViewController.swift
//  todo<sudha>
//
//  Created by Student 06 on 02/02/19.
//  Copyright © 2019 Student 06. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    var delegate : AppDelegate!
    var List : [Any] = []

    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var ContacttextField: UITextField!
    
    @IBOutlet weak var empolyeeTextField: UITextField!
    
    @IBOutlet weak var departmentTextField: UITextField!
    
    @IBOutlet weak var salaryTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = (UIApplication.shared.delegate as! AppDelegate)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        let context = delegate.persistentContainer.viewContext;
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        do{
            List = try context.fetch(request)
        }catch{
            print("Error in fetching data")
        }
        self.TableView.reloadData()
    }
    

    @IBAction func Insert(_ sender: UIButton) {
        let context = delegate.persistentContainer.viewContext;
        let empObj : NSObject = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        
        empObj.setValue(nameTextfield.text, forKey: "name")
        empObj.setValue(empolyeeTextField.text, forKey: "empid")
        empObj.setValue(departmentTextField.text, forKey: "detpid")
        empObj.setValue(ContacttextField.text, forKey: "contactNo")
        
        let numberFormatter = NumberFormatter()
        let salary = numberFormatter.number(from: salaryTextField.text!);
        
        empObj.setValue(salary, forKey: "salary")
        
        do{
            try context.save()
        }catch{
            print("Error in inserting data");
        }
        empolyeeTextField.text = ""
        nameTextfield.text = ""
        departmentTextField.text = ""
        ContacttextField.text = ""
        salaryTextField.text = ""
        self.readData()
    }
    
    @IBAction func Update(_ sender: UIButton) {
        let context = delegate.persistentContainer.viewContext;
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        request.predicate = NSPredicate(format: "name =%@", nameTextfield.text!)
        request.returnsObjectsAsFaults = false
        
        
        do{
            let result = try context.fetch(request)
            
            if result.count == 1
            {
                let data : NSManagedObject = result.first as! NSManagedObject
                data.setValue(nameTextfield.text, forKey: "name")
                data.setValue(empolyeeTextField.text, forKey: "empid")
                data.setValue(departmentTextField.text, forKey: "detpid")
                data.setValue(ContacttextField.text, forKey: "contactNo")
                
                let numberFormatter = NumberFormatter()
                let salary = numberFormatter.number(from: salaryTextField.text!)
                
                data.setValue(salary, forKey: "salary");
                
                do{
                    try context.save()
                }catch{
                    print("ERROR :: \(error.localizedDescription)");
                }
            }
        }catch{
            print("ERROR in updating :: \(error.localizedDescription)");
        }
        
        
        salaryTextField.text = ""
        departmentTextField.text = ""
        empolyeeTextField.text = ""
        ContacttextField.text = ""
        nameTextfield.text = ""
        
        self.TableView.reloadData()
    }
    
    @IBAction func Delete(_ sender: UIButton) {
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        request.predicate = NSPredicate(format: "name =%@", nameTextfield.text!)
        request.returnsObjectsAsFaults = false
        
        
        do{
            let result = try context.fetch(request)
            
            if result.count == 1
            {
                let data : NSManagedObject = result.first as! NSManagedObject;
                context.delete(data)
                
                do{
                    try context.save()
                }catch{
                    print("ERROR :: \(error.localizedDescription)");
                }
            }
        }catch{
            print("ERROR in updating :: \(error.localizedDescription)")
        }
        
        salaryTextField.text = ""
        departmentTextField.text = ""
        empolyeeTextField.text = ""
        ContacttextField.text = ""
        nameTextfield.text = ""
        
        self.readData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return List.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        let data : NSManagedObject = List[indexPath.row] as! NSManagedObject
        cell.textLabel?.text = (data.value(forKey: "name") as! String)
        cell.detailTextLabel?.text = (data.value(forKey: "empid") as! String)
        
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let context = delegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        let data : NSManagedObject = List[indexPath.row] as! NSManagedObject
        
        request.predicate = NSPredicate(format: "name =%@", (data.value(forKey: "name") as! String))
        request.returnsObjectsAsFaults = false
        
        
        do{
            let result = try context.fetch(request)
            
            if result.count == 1
            {
                let data : NSManagedObject = result.first as! NSManagedObject;
                self.nameTextfield.text = (data.value(forKey: "name") as! String)
                self.empolyeeTextField.text = (data.value(forKey: "empid") as! String)
                self.ContacttextField.text = (data.value(forKey: "contactNo") as! String)
                self.departmentTextField.text = (data.value(forKey: "detpid") as! String)
                
                //let numFormatter = NumberFormatter()
                let sal = data.value(forKey: "salary")
                
                self.salaryTextField.text = (sal as AnyObject).stringValue
            }
        }catch{
            print("ERROR in updating :: \(error.localizedDescription)")
        }
    }
    func readData() {
        let context = delegate.persistentContainer.viewContext;
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        do{
            List = try context.fetch(request)
        }catch{
            print("Error in fetching data")
        }
        self.TableView.reloadData()
    }


}

