//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Arin Asawa on 7/20/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController,ToDoCellDelegate {
    
    var toDoListItems = [ToDoItem]()
    var filteredToDoListItems = [ToDoItem]()
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty:Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering:Bool{
        return searchController.isActive && !isSearchBarEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up search controller and add its search bar to the view controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Notes"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        navigationItem.leftBarButtonItem = editButtonItem
        if let savedToDos = ToDoItem.loadToDos(){
            self.toDoListItems = savedToDos
        }else{
            self.toDoListItems = ToDoItem.loadSampleToDos()
        }
    }
    
 
 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredToDoListItems.count
        }
        return toDoListItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath) as? ToDoCell else{
            fatalError("Could not dequeue cell!")
        }
        let toDoItem:ToDoItem
        if isFiltering{
            toDoItem = filteredToDoListItems[indexPath.row]
        }else{
            toDoItem = toDoListItems[indexPath.row]
        }
        cell.titleLabel?.text = toDoItem.title
        cell.delegate = self
        cell.isCompleteButton?.isSelected = toDoItem.isComplete
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            toDoListItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDoItem.saveToDos(self.toDoListItems)
        }
    }
    
    
    @IBAction func unwindToDoList(segue:UIStoryboardSegue){
        guard segue.identifier == "saveUnwind" else{
            if let selected = tableView.indexPathForSelectedRow{
                tableView.deselectRow(at: selected, animated: true)
            }
            return
        }
        let ToDoDetailTableViewController = segue.source as! ToDoDetailTableViewController
        if let toDo = ToDoDetailTableViewController.toDo{
            if let selected = tableView.indexPathForSelectedRow{
                toDoListItems[selected.row] = toDo
                tableView.reloadRows(at: [selected], with: .none)
                tableView.deselectRow(at: selected, animated: true)
            }else{
                let newIndexPath = IndexPath(row: toDoListItems.count, section: 0)
                toDoListItems.append(toDo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDoItem.saveToDos(toDoListItems)
        
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  segue.identifier == "EditToDo" else {return}
        let toDoItem : ToDoItem
        if isFiltering{
            toDoItem = filteredToDoListItems[tableView.indexPathForSelectedRow!.row]
        }else{
            toDoItem = toDoListItems[tableView.indexPathForSelectedRow!.row]
        }
        let navigationController = segue.destination as! UINavigationController
        let ToDoDetailTableViewController = navigationController.topViewController as! ToDoDetailTableViewController
        ToDoDetailTableViewController.navigationItem.title = "Edit ToDo"
        ToDoDetailTableViewController.toDo = toDoItem
    }
    
    func checkmarkTapped(sender: ToDoCell) {
          sender.isCompleteButton?.isSelected.toggle()
          let indexPath = tableView.indexPath(for: sender)!
          toDoListItems[indexPath.row].isComplete.toggle()
          ToDoItem.saveToDos(toDoListItems)
      }
    
    func filterContentForSearchText(_ searchText: String) {
      filteredToDoListItems = toDoListItems.filter { (ToDoItem: ToDoItem) -> Bool in
        return ToDoItem.title.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
}

extension ToDoListTableViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    
    
}
