//
//  MealTableViewController.swift
//  FoodTracker2
//
//  Created by Toan on 11/24/18.
//  Copyright © 2018 Toan. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController,UISearchBarDelegate,UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredMeals = meals.filter({ meal in
                return meal.name.lowercased().contains(searchText.lowercased())
            })}
            else {
                filteredMeals = meals
            }
        tableView.reloadData()
        
    }
    var filteredMeals = [Meal]()
    
    var searchController = UISearchController(searchResultsController: nil)
    //MARK: Private Methods
    var meals = [Meal]()
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "Image1")
        let photo2 = UIImage(named: "Image2")
        let photo3 = UIImage(named: "Image3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3) else {
            fatalError("Unable to instantiate meal2")
        }
        meals += [meal1, meal2, meal3]
    }
    
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        if isSuccessfulSave {
                os_log("Meals successfully", log: .default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: .default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
        loadSampleMeals()
        navigationItem.leftBarButtonItem = editButtonItem
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.isActive = true
        definesPresentationContext = true
        navigationItem.searchController = searchController
//        updateSearchResults(for: <#T##UISearchController#>)
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredMeals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let meal = filteredMeals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        // Configure the cell...

        return cell
    }
//    func prepare(segue: UIStoryboardSegue, sender: AnyObject?) {
//        super.prepare(for: segue, sender: sender)
//
//
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? ViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = filteredMeals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
            if let sourceViewController = sender.source as? ViewController, let meal = sourceViewController.meal {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                let newIndexPath = IndexPath(row: meals.count, section: 0)
//                meals.append(meal)
//                tableView.insertRows(at: [newIndexPath], with: .automatic)
                    if let index = meals.index(of: filteredMeals[selectedIndexPath.row]) {
                        meals[index] = meal
                        filteredMeals[selectedIndexPath.row] = meal
                        searchController.isActive = true
                    }
                // Edit a meal
                    
//                meals[selectedIndexPath.row] = meal
//                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            
            } else {
                // Add a new meal
//                let newIndexPath = IndexPath(row: meals.count, section: 0)
//                meals.append(meal)
//                tableView.insertRows(at: [newIndexPath], with: .automatic)
                meals.append(meal)
                filteredMeals = meals
                searchController.isActive = true
                tableView.reloadData()
            }
            // Save meal
            saveMeals()
        }
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveMeals()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
