//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Arin Asawa on 7/22/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {

    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var dueDatePickerView: UIDatePicker!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var isCompleteButton: UIButton!
    @IBOutlet var saveButton: UIBarButtonItem!
    var toDo:ToDoItem?
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notestextViewIndexPath = IndexPath(row: 0, section: 2)
    let normalCellHeight:CGFloat = 44
    let largeCellHeight : CGFloat = 200
    var isPickerHidden = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        if let toDo = self.toDo{
            self.isCompleteButton.isSelected = toDo.isComplete
            self.dueDatePickerView.date = toDo.dueDate
            self.notesTextView.text = toDo.notes
            self.titleTextField.text = toDo.title
        }else{
            dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
        }
        updateSaveButtonState()
        updateDueDateLabel(date: dueDatePickerView.date)
    }

    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    func updateSaveButtonState(){
        let text = titleTextField.text ?? ""
        self.saveButton.isEnabled = !text.isEmpty
    }
    
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        self.isCompleteButton.isSelected.toggle()
    }
    
    func updateDueDateLabel(date:Date){
        self.dueDateLabel.text = ToDoItem.dueDateFormatter.string(from: date)
    }
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dateLabelIndexPath{
            self.isPickerHidden.toggle()
            dueDateLabel.textColor = isPickerHidden ? .black:tableView.tintColor
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
        case datePickerIndexPath:
            return isPickerHidden ? 0:self.dueDatePickerView.frame.height
        case notestextViewIndexPath:
            return largeCellHeight
        default:
            return normalCellHeight
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else {return}
        self.toDo =  ToDoItem(title: titleTextField.text!, isComplete: isCompleteButton.isSelected, dueDate: dueDatePickerView.date, notes: notesTextView.text)
    }
}
