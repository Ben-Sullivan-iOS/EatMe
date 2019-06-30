//
//  ViewController.swift
//  Eat Me
//
//  Created by Daniel Hilton on 19/05/2019.
//  Copyright © 2019 Daniel Hilton. All rights reserved.

// TODO: -


import UIKit
import RealmSwift
import Charts
import ChameleonFramework

class OverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewEntryDelegate {
    
    let realm = try! Realm()
    
    //MARK: - Properties and Objects
    private var foodList: Results<Food>?
    private let food = Food()

    @IBOutlet weak var eatMeTableView: UITableView!
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    
    var totalCals: Int!
    
    private let defaults = UserDefaults.standard
    
    private var refreshControl = UIRefreshControl()
    
    //MARK: - view Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalCals = defaults.integer(forKey: "totalCalories")
        
        eatMeTableView.delegate = self
        eatMeTableView.dataSource = self
        
        eatMeTableView.separatorStyle = .none
        
        eatMeTableView.register(UINib(nibName: "MealOverviewCell", bundle: nil), forCellReuseIdentifier: "mealOverviewCell")
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        eatMeTableView.addSubview(refreshControl)
        
        loadAllFood()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAllFood()
    }
    
    
    func loadAllFood() {
        
        foodList = realm.objects(Food.self)
        
        totalCaloriesLabel.text = "Total Calories: \(totalCals!)"
        
        eatMeTableView.reloadData()
        
    }
    
    @objc func refresh() {
        loadAllFood()
        refreshControl.endRefreshing()
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
        
        cell.pieChart.legend.enabled = false
        cell.pieChart.holeRadiusPercent = 0.5
        cell.pieChart.highlightPerTapEnabled = false
        
        
        switch indexPath.section {
            
        case 0:
            getSumOfPropertiesForMeal(food: foodList, meal: .breakfast, cell: cell)
        case 1:
            getSumOfPropertiesForMeal(food: foodList, meal: .lunch, cell: cell)
        case 2:
            getSumOfPropertiesForMeal(food: foodList, meal: .dinner, cell: cell)
        case 3:
            getSumOfPropertiesForMeal(food: foodList, meal: .other, cell: cell)
        default:
            cell.calorieLabel.text = "0"
            cell.proteinLabel.text = "0"
            cell.carbsLabel.text = "0"
            cell.fatLabel.text = "0"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToMealDetail", sender: nil)
        
    }
    
    //MARK: - Methods to Update UI with user's entry data
    
    
    func getSumOfPropertiesForMeal(food: Results<Food>?, meal: Food.Meal, cell: MealOverviewCell) {
        
        var calorieArray = [NSNumber]()
        var proteinArray = [NSNumber]()
        var carbsArray = [NSNumber]()
        var fatArray = [NSNumber]()
        
        var calories = 0
        var protein = 0.0
        var carbs = 0.0
        var fat = 0.0
        
        
        
        if let foodlist = food {
            if meal == .breakfast {
                for i in 0..<foodlist.count {
                    if foodlist[i].meal == "breakfast" {
                        calorieArray.append(foodlist[i].calories ?? 0)
                        proteinArray.append(foodlist[i].protein ?? 0)
                        carbsArray.append(foodlist[i].carbs ?? 0)
                        fatArray.append(foodlist[i].fat ?? 0)
                    }
                }
                for i in 0..<calorieArray.count {
                    calories += Int(truncating: calorieArray[i])
                    protein += Double(truncating: proteinArray[i])
                    carbs += Double(truncating: carbsArray[i])
                    fat += Double(truncating: fatArray[i])
                }
            }
            else if meal == .lunch {
                for i in 0..<foodlist.count {
                    if foodlist[i].meal == "lunch" {
                        calorieArray.append(foodlist[i].calories ?? 0)
                        proteinArray.append(foodlist[i].protein ?? 0)
                        carbsArray.append(foodlist[i].carbs ?? 0)
                        fatArray.append(foodlist[i].fat ?? 0)
                    }
                }
                for i in 0..<calorieArray.count {
                    calories += Int(truncating: calorieArray[i])
                    protein += Double(truncating: proteinArray[i])
                    carbs += Double(truncating: carbsArray[i])
                    fat += Double(truncating: fatArray[i])
                }
            }
            else if meal == .dinner {
                for i in 0..<foodlist.count {
                    if foodlist[i].meal == "dinner" {
                        calorieArray.append(foodlist[i].calories ?? 0)
                        proteinArray.append(foodlist[i].protein ?? 0)
                        carbsArray.append(foodlist[i].carbs ?? 0)
                        fatArray.append(foodlist[i].fat ?? 0)
                    }
                }
                for i in 0..<calorieArray.count {
                    calories += Int(truncating: calorieArray[i])
                    protein += Double(truncating: proteinArray[i])
                    carbs += Double(truncating: carbsArray[i])
                    fat += Double(truncating: fatArray[i])
                }
            }
            else if meal == .other {
                for i in 0..<foodlist.count {
                    if foodlist[i].meal == "other" {
                        calorieArray.append(foodlist[i].calories ?? 0)
                        proteinArray.append(foodlist[i].protein ?? 0)
                        carbsArray.append(foodlist[i].carbs ?? 0)
                        fatArray.append(foodlist[i].fat ?? 0)
                    }
                }
                for i in 0..<calorieArray.count {
                    calories += Int(truncating: calorieArray[i])
                    protein += Double(truncating: proteinArray[i])
                    carbs += Double(truncating: carbsArray[i])
                    fat += Double(truncating: fatArray[i])
                }
            }
        }
        
        
        cell.calorieLabel.text = "\(calories) kcal"
        cell.proteinLabel.text = "\(protein) g"
        cell.carbsLabel.text = "\(carbs) g"
        cell.fatLabel.text = "\(fat) g"
        
        
        
//        let colors = [(UIColor(red:0.57, green:0.76, blue:0.86, alpha:1.0)),                                                 (UIColor(red:0.47, green:0.86, blue:0.74, alpha:1.0)),
//                      (UIColor(red:0.99, green:0.53, blue:0.94, alpha:1.0))]
        
        if protein == 0 && carbs == 0 && fat == 0 {
            
            let chartDataSet = PieChartDataSet(entries: [PieChartDataEntry(value: 1.0),
                               PieChartDataEntry(value:
                               1.0), PieChartDataEntry(value: 1.0)], label: nil)
            let chartData = PieChartData(dataSet: chartDataSet)
            chartDataSet.drawValuesEnabled = false
            chartDataSet.colors = [UIColor.flatSkyBlue(), UIColor.flatMint(), UIColor.flatWatermelon()]
            cell.pieChart.data = chartData
            
        } else {
        
            let pieChartEntries = [PieChartDataEntry(value: protein), PieChartDataEntry(value: carbs),
                                   PieChartDataEntry(value: fat)]
            let chartDataSet = PieChartDataSet(entries: pieChartEntries, label: nil)
            let chartData = PieChartData(dataSet: chartDataSet)
            chartDataSet.drawValuesEnabled = false
            chartDataSet.colors = [UIColor.flatSkyBlue(), UIColor.flatMint(), UIColor.flatWatermelon()]
            
            cell.pieChart.data = chartData
        }
        
    }
    
    func getCalorieDataFromNewEntry(data: Int) {
        
        totalCals += data
        defaults.set(totalCals, forKey: "totalCalories")
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToNewEntry" {
            let nc = segue.destination as! UINavigationController
            let vc = nc.topViewController as! NewEntryViewController
            vc.delegate = self
            
        }
        else if segue.identifier == "goToMealDetail" {
            
            let destVC = segue.destination as! MealDetailViewController
            
            if let indexPath = eatMeTableView.indexPathForSelectedRow {
                
                if indexPath.section == 0 {
                    let resultPredicate = NSPredicate(format: "meal contains[c] %@", "breakfast")
                    destVC.selectedMeal = foodList?.filter(resultPredicate)
                    destVC.navigationItem.title = "Breakfast"
                }
                else if indexPath.section == 1 {
                    let resultPredicate = NSPredicate(format: "meal contains[c] %@", "lunch")
                    destVC.selectedMeal = foodList?.filter(resultPredicate)
                    destVC.navigationItem.title = "Lunch"
                }
                else if indexPath.section == 2 {
                    let resultPredicate = NSPredicate(format: "meal contains[c] %@", "dinner")
                    destVC.selectedMeal = foodList?.filter(resultPredicate)
                    destVC.navigationItem.title = "Dinner"
                }
                else if indexPath.section == 3 {
                    let resultPredicate = NSPredicate(format: "meal contains[c] %@", "other")
                    destVC.selectedMeal = foodList?.filter(resultPredicate)
                    destVC.navigationItem.title = "Other"
                }
            }
        }
    }
    
    
    



}


