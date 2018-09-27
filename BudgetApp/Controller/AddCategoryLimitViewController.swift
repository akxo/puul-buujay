//
//  AddCategoryLimitViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 8/7/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class AddCategoryLimitViewController: UIViewController, UITextFieldDelegate {

    var category: Category?
    
    var categoryName: String?
    
    var limit: Int? {
        didSet {
            limitLabel.text = "$\(limit ?? 0)"
            messageLabel.text = "A budget of \(limitLabel.text ?? "$0") will be set for \(categoryName ?? "the category")."
            saveButton.isEnabled = (limit ?? 0) != 0
        }
    }
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var limitLabel: UILabel!
    
    @IBOutlet weak var referenceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        category = OverviewViewController.budget.categories.first(where: { $0.name.lowercased() == categoryName?.lowercased() })
        categoryName = category?.name ?? categoryName
        limit = category?.limit ?? 0
        
        referenceTextField.becomeFirstResponder()
        referenceTextField.tintColor = UIColor.clear
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = categoryName
    }
    
    @IBAction func saveCategory(_ sender: UIBarButtonItem) {
        guard let name = categoryName, let limit = self.limit else { return }
        if let _ = category {
            OverviewViewController.budget.changeCategoryLimit(categoryName: name, newLimit: limit)
        } else {
            OverviewViewController.budget.addCategory(category: Category(name: name, limit: limit))
        }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if let newLimit = Int(referenceTextField.text ?? "0") {
            limit = newLimit
        } else {
            limit = 0
        }
    }
    
}
