//
//  PageViewController.swift
//  Eat Me
//
//  Created by Daniel Hilton on 06/07/2019.
//  Copyright © 2019 Daniel Hilton. All rights reserved.
//
import Foundation
import UIKit

class OverviewPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let overviewVC = storyboard?.instantiateViewController(withIdentifier: "OverviewVC") as? OverviewViewController {
            
            // Set the PageViewController nav bar to the same as OverviewViewController
            //            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 30)!]
            self.navigationItem.title = overviewVC.navigationItem.title
            overviewVC.date = Date()

            self.navigationItem.leftBarButtonItems = overviewVC.navigationItem.leftBarButtonItems
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))]
            
            setViewControllers([overviewVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @objc func addTapped() {
        guard
            let popupNav = storyboard?.instantiateViewController(withIdentifier: "PopupVCNav") as? UINavigationController,
            let popupVC = popupNav.viewControllers.first as? PopUpNewEntryViewController,
            let vc = viewControllers?[0] as? OverviewViewController
            else {
                return
        }
        popupVC.delegate = vc
        popupVC.date = vc.date
        present(popupNav, animated: true)
    }
    
    private func overviewViewController(for date: Date) -> OverviewViewController? {
        // Return a new instance of OverviewViewController and set the date property.
        
        guard let overviewPage = storyboard?.instantiateViewController(withIdentifier: "OverviewVC") as? OverviewViewController else { return nil }
        
        overviewPage.configureWith(date: date)
        
        return overviewPage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let selectedDate = (viewController as! OverviewViewController).date else { return nil }

        // Yesterday's date at time: 00:00
        guard var previousDate = calendar.date(byAdding: .day, value: -1, to: selectedDate) else { return nil }
        previousDate = calendar.startOfDay(for: previousDate)
        previousDate = calendar.date(byAdding: .hour, value: 1, to: previousDate) ?? previousDate
        print("BEFORE Selected date ", selectedDate, "previousDate ", previousDate)

        return overviewViewController(for: Date())
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let selectedDate = (viewController as! OverviewViewController).date else { return nil }
        
        // Tomorrow's date at time: 00:00
        guard var futureDate = calendar.date(byAdding: .day, value: 1, to: selectedDate) else { return nil }
        futureDate = calendar.startOfDay(for: futureDate)
        futureDate = calendar.date(byAdding: .hour, value: 1, to: futureDate) ?? futureDate
        print("AFTER Selected date ", selectedDate, "futureDate ", futureDate)
        
        return overviewViewController(for: futureDate)
        
    }
    
    
    @IBAction func goToToday(_ sender: Any) {
        
        present(overviewViewController(for: Date())!, animated: true, completion: nil)
        
    }


}

extension Notification.Name {
    // Create a new notification name
    static let dateNotification = Notification.Name(rawValue: dateNotificationKey)
}

