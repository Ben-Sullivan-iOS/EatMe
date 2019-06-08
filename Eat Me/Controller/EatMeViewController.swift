//
//  ViewController.swift
//  Eat Me
//
//  Created by Daniel Hilton on 19/05/2019.
//  Copyright © 2019 Daniel Hilton. All rights reserved.

// TODO: - Configue the Lunch, Dinner and Other cells to update with new entries.


import UIKit
import RealmSwift

class EatMeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewEntryDelegate {
    
    let realm = try! Realm()
    
    let newEntryVC = NewEntryViewController()
    
    //MARK: - Properties and Objects
    
    var breakfastFoods: Results<BreakfastFood>?
    var lunchFoods: Results<LunchFood>?
    var dinnerFoods: Results<DinnerFood>?
    var otherFoods: Results<OtherFood>?

    @IBOutlet weak var eatMeTableView: UITableView!
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    
    var totalCals: Int!
    
    let defaults = UserDefaults.standard
    
    
    var refreshControl = UIRefreshControl()
    
    //MARK: - view Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.newEntryVC.delegate = self
        totalCals = defaults.integer(forKey: "totalCalories")
        
        eatMeTableView.delegate = self
        eatMeTableView.dataSource = self
        
        eatMeTableView.separatorStyle = .none
        
        eatMeTableView.register(UINib(nibName: "MealOverviewCell", bundle: nil), forCellReuseIdentifier: "mealOverviewCell")
        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        eatMeTableView.addSubview(refreshControl)
        
        loadAllFood()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        loadAllFood()
    }
    
    @objc func refresh() {
        loadAllFood()
        refreshControl.endRefreshing()
    }
    
    func loadAllFood() {
        
        breakfastFoods = realm.objects(BreakfastFood.self)
        lunchFoods = realm.objects(LunchFood.self)
        dinnerFoods = realm.objects(DinnerFood.self)
        otherFoods = realm.objects(OtherFood.self)
        
        totalCaloriesLabel.text = "Total Calories: \(totalCals!)"
        
        eatMeTableView.reloadData()
        
    }
    
    
    //MARK: - Tableview Data Source Methods
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        label.textColor = UIColor.black
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 21)
        
        switch section {
        case 0:
            label.text = "   Breakfast"
        case 1:
            label.text = "   Lunch"
        case 2:
            label.text = "   Dinner"
        case 3:
            label.text = "   Other"
        default:
            label.text = ""
        }
        
        return label
            
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealOverviewCell", for: indexPath) as! MealOverviewCell
        
        
        switch indexPath.section {
        case 0:
            getSumOfPropertiesForMeal(meal1: breakfastFoods, meal2: nil, meal3: nil, meal4: nil, cell: cell)
        case 1:
            getSumOfPropertiesForMeal(meal1: nil, meal2: lunchFoods, meal3: nil, meal4: nil, cell: cell)
        case 2:
            getSumOfPropertiesForMeal(meal1: nil, meal2: nil, meal3: dinnerFoods, meal4: nil, cell: cell)
        case 3:
            getSumOfPropertiesForMeal(meal1: nil, meal2: nil, meal3: nil, meal4: otherFoods, cell: cell)
        default:
            cell.calorieLabel.text = "0"
            cell.proteinLabel.text = "0"
            cell.carbsLabel.text = "0"
            cell.fatLabel.text = "0"
        }
        
        return cell
        
    }
    
    
    func getSumOfPropertiesForMeal(meal1: Results<BreakfastFood>?, meal2: Results<LunchFood>?, meal3: Results<DinnerFood>?, meal4: Results<OtherFood>?, cell: MealOverviewCell) {
        
        var calorieArray = [NSNumber]()
        var proteinArray = [NSNumber]()
        var carbsArray = [NSNumber]()
        var fatArray = [NSNumber]()
        
        var calories = 0
        var protein = 0.0
        var carbs = 0.0
        var fat = 0.0
        
        if let foodList = meal1 {
            for i in 0..<foodList.count {
                calorieArray.append(foodList[i].calories ?? 0)
                proteinArray.append(foodList[i].protein ?? 0)
                carbsArray.append(foodList[i].carbs ?? 0)
                fatArray.append(foodList[i].fat ?? 0)
            }
            
            for i in 0..<calorieArray.count {
                calories += Int(truncating: calorieArray[i])
                protein += Double(truncating: proteinArray[i])
                carbs += Double(truncating: carbsArray[i])
                fat += Double(truncating: fatArray[i])
            }
            
        } else if let foodList = meal2 {
            
            for i in 0..<foodList.count {
                calorieArray.append(foodList[i].calories ?? 0)
                proteinArray.append(foodList[i].protein ?? 0)
                carbsArray.append(foodList[i].carbs ?? 0)
                fatArray.append(foodList[i].fat ?? 0)
            }
            
            for i in 0..<calorieArray.count {
                calories += Int(truncating: calorieArray[i])
                protein += Double(truncating: proteinArray[i])
                carbs += Double(truncating: carbsArray[i])
                fat += Double(truncating: fatArray[i])
            }
            
        } else if let foodList = meal3 {
            
            for i in 0..<foodList.count {
                calorieArray.append(foodList[i].calories ?? 0)
                proteinArray.append(foodList[i].protein ?? 0)
                carbsArray.append(foodList[i].carbs ?? 0)
                fatArray.append(foodList[i].fat ?? 0)
            }
            
            for i in 0..<calorieArray.count {
                calories += Int(truncating: calorieArray[i])
                protein += Double(truncating: proteinArray[i])
                carbs += Double(truncating: carbsArray[i])
                fat += Double(truncating: fatArray[i])
            }
            
        } else if let foodList = meal4 {
            
            for i in 0..<foodList.count {
                calorieArray.append(foodList[i].calories ?? 0)
                proteinArray.append(foodList[i].protein ?? 0)
                carbsArray.append(foodList[i].carbs ?? 0)
                fatArray.append(foodList[i].fat ?? 0)
            }
            
            for i in 0..<calorieArray.count {
                calories += Int(truncating: calorieArray[i])
                protein += Double(truncating: proteinArray[i])
                carbs += Double(truncating: carbsArray[i])
                fat += Double(truncating: fatArray[i])
            }
            
        }
        
        cell.calorieLabel.text = "\(calories) kcal"
        cell.proteinLabel.text = "\(protein) g"
        cell.carbsLabel.text = "\(carbs) g"
        cell.fatLabel.text = "\(fat) g"
        
        
    }
    
    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error deleting data - \(error)")
        }
        
        totalCals = 0
        defaults.set(0, forKey: "totalCalories")
        loadAllFood()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewEntry" {
            let vc = segue.destination as! NewEntryViewController
            vc.delegate = self
        }
    }
    
    func getCalorieDataFromNewEntry(data: Int) {
        
        totalCals += data
        defaults.set(totalCals, forKey: "totalCalories")
        print(data)
    }
    



}



