//
//  NewEntryViewController.swift
//  Eat Me
//
//  Created by Daniel Hilton on 31/05/2019.
//  Copyright © 2019 Daniel Hilton. All rights reserved.
//

import UIKit
import RealmSwift

protocol NewEntryDelegate: class {
    func getCalorieDataFromNewEntry(data: Int)
}

class NewEntryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    weak var delegate: NewEntryDelegate?
    

    //MARK: - Properties and Objects
    
    @IBOutlet weak var mealPicker: UISegmentedControl!
    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var carbsTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

       
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }

    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        switch mealPicker.selectedSegmentIndex {
            
        case 0:
            
            let newBreakfastFood = Food()
                
            addAndSaveNewEntry(newFood: newBreakfastFood, meal: .breakfast)
            
        case 1:
            
            let newLunchFood = Food()
            
            addAndSaveNewEntry(newFood: newLunchFood, meal: .lunch)
            
        case 2:
            
            let newDinnerFood = Food()
            
            addAndSaveNewEntry(newFood: newDinnerFood, meal: .dinner)
            
        case 3:
            
            let newOtherFood = Food()
            
            addAndSaveNewEntry(newFood: newOtherFood, meal: .other)
            
        default:
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
        
    
    func save(food: Object) {
        
        do {
            try realm.write {
                realm.add(food)
            }
        } catch {
            print(error)
        }
        
        
    }
    
    func addAndSaveNewEntry(newFood: Food?, meal: Food.Meal) {
        
        if let newFoodEntry = newFood {
        newFoodEntry.updateProperties(meal: meal, name: foodNameTextField.text, calories: NSNumber(value: Int(caloriesTextField.text!) ?? 0), protein: NSNumber(value: Double(proteinTextField.text!) ?? 0), carbs: NSNumber(value: Double(carbsTextField.text!) ?? 0), fat: NSNumber(value: Double(fatTextField.text!) ?? 0))
        
        if let newEntryCalories = caloriesTextField.text {
            delegate?.getCalorieDataFromNewEntry(data: Int(newEntryCalories) ?? 0)
        }
        
        save(food: newFoodEntry)
        }
        
        
    }
    
}
