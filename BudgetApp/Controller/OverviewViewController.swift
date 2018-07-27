//
//  ViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/16/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static var budget: Budget {
        return getBudget()
    }
    
    var numberOfRecentTransactions = 5
    
    @IBOutlet weak var budgetView: UIView!
    
    @IBOutlet weak var budgetProgress: UIProgressView!
    
    @IBOutlet weak var todayValueConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var recentTransactionsLabel: UILabel!
    @IBOutlet weak var recentTransactionsTableview: UITableView!
    
    @IBAction func allTransactionsButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        recentTransactionsTableview.register(nib, forCellReuseIdentifier: "TransactionTableViewCell")
        recentTransactionsTableview.isScrollEnabled = false
        
        // clear data
//        RootViewController.deleteBudget()
        
        // Budget View
        budgetProgress.transform = budgetProgress.transform.scaledBy(x: 1, y: 8)
        budgetProgress.trackTintColor = #colorLiteral(red: 0.862745098, green: 0.8509803922, blue: 0.8549019608, alpha: 1)
        budgetProgress.progressTintColor = #colorLiteral(red: 0, green: 0.7675034874, blue: 0.2718033226, alpha: 0.7043225365)
        budgetProgress.progress = OverviewViewController.budget.getProgress(categoryName: "All")
        
        monthLabel.text = "\(OverviewViewController.budget.getMonths().first ?? "") Budget"
        
        todayValueConstraint.constant = (budgetProgress.frame.width * OverviewViewController.budget.getTodayValue(categoryName: "All")) + 20.0
        
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.budgetViewTapped(_: )))
        budgetView.addGestureRecognizer(gesture)
        

        
    }
    
    @objc private func budgetViewTapped(_ sender: UIGestureRecognizer) {
        performSegue(withIdentifier: "toBudgetDetail", sender: self)
    }
    
    // Recent Transactions TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UIScreen.main.bounds.height < 600 {
            numberOfRecentTransactions = 3
        } else if UIScreen.main.bounds.height < 700 {
            numberOfRecentTransactions = 4
        } else {
            numberOfRecentTransactions = 5
        }
        return numberOfRecentTransactions
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return recentTransactionsTableview.frame.height / CGFloat(numberOfRecentTransactions)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        if indexPath.row < OverviewViewController.budget.allTransactions.count {
            let transaction = OverviewViewController.budget.allTransactions[indexPath.row]
            let transactionInfo = transaction.getAllInfo()
            cell.monthLabel.text = transactionInfo[0]
            cell.dayLabel.text = transactionInfo[1]
            cell.merchantLabel.text = transactionInfo[2]
            cell.categoryLabel.text = transactionInfo[3]
            cell.integerAmountLabel.text = transactionInfo[4]
            cell.decimalAmountLabel.text = transactionInfo[5]
            cell.isUserInteractionEnabled = true
        } else {
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTransaction" {
            let backItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: nil)
            navigationItem.backBarButtonItem = backItem
            navigationItem.backBarButtonItem?.tintColor = UIColor.white
        } else if segue.identifier == "toBudgetDetail" {
            let backItem = UIBarButtonItem(title: "Overview", style: UIBarButtonItemStyle.done, target: self, action: nil)
            navigationItem.backBarButtonItem = backItem
            navigationItem.backBarButtonItem?.tintColor = UIColor.white
            let destination = segue.destination as? BudgetViewController
            destination?.monthNames = OverviewViewController.budget.getMonths()
        }
    }
    
    static func getBudget() -> Budget {
        guard let budgetData = UserDefaults.standard.object(forKey: "budgetData") as? Data,
            let budget = NSKeyedUnarchiver.unarchiveObject(with: budgetData) as? Budget else {return Budget()}
        return budget
    }
    
    static func saveBudget() {
        let budgetData = NSKeyedArchiver.archivedData(withRootObject: budget)
        UserDefaults.standard.set(budgetData, forKey: "budgetData")
    }
    
    static func deleteBudget() {
        UserDefaults.standard.removeObject(forKey: "budgetData")
    }
}

