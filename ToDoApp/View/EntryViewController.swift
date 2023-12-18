//
//  EntryViewController.swift
//  ToDoApp
//
//  Created by Gülfem Albayrak on 18.12.2023.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var field: UITextField!
    var task: String?
    var update: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        if let taskText = task {
            field.text = taskText
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else {
            return
        }
       
        if var tasks = UserDefaults().array(forKey: "tasks") as? [String] {
            tasks.insert(text, at: 0)
            UserDefaults().set(tasks, forKey: "tasks")
        } else {
            let tasks = [text]
            UserDefaults().set(tasks, forKey: "tasks")
        }
        
        update?()
        navigationController?.popViewController(animated: true)
    }
}
