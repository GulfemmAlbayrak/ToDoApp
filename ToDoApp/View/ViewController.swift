//
//  ViewController.swift
//  ToDoApp
//
//  Created by Gülfem Albayrak on 18.12.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var newTasksTableView: UITableView!
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newTasksTableView.delegate = self
        newTasksTableView.dataSource = self
        
        //SETUP
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().setValue(true, forKey: "setup")
            UserDefaults().set(0, forKey:"count")
        }
        // Get all current saved tasks
        updateTasks()
    }

    
    func updateTasks(){
        if let savedTasks = UserDefaults().array(forKey: "tasks") as? [String] {
            tasks = savedTasks
            newTasksTableView.reloadData()
            print(tasks)
        }
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasksCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editingVC = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        editingVC.title = "Edit Task"
        editingVC.task = tasks[indexPath.row]
        
        navigationController?.pushViewController(editingVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at:  [indexPath], with: .automatic)
            UserDefaults.standard.set(tasks, forKey: "tasks")
        }
    }
    
}
