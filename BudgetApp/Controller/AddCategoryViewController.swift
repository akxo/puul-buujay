//
//  AddCategoryViewController.swift
//  BudgetApp
//
//  Created by Alexander Kerendian on 7/30/18.
//  Copyright © 2018 Alexander Kerendian. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let suggestedCategories = ["Groceries", "Rent", "Car Payment", "Transportation", "Shopping", "Mortgage", "Cable & Wifi", "Utilities", "Bar", "Mobile Phone", "Vacation", "Student Loan", "Tuition", "Health Insurance", "Gym", "Auto Insurance", "Life Insurance"]
    
    var filteredSuggestedCategories: [String] = []
    
    var filteredCustomCategories: [Category] = []
    
    var isSearching: Bool = false
    
    var selectedCategory: String?
    
    var selectedIndex: Int?
    
    @IBOutlet weak var categorySearchBar: UISearchBar!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        categorySearchBar.backgroundColor = #colorLiteral(red: 0.4039215686, green: 0.5254901961, blue: 0.7176470588, alpha: 1)
    
        filteredSuggestedCategories = suggestedCategories
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteredCustomCategories = OverviewViewController.budget.categories
        categoriesTableView.reloadData()
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategoryLimit" {
            let destination = segue.destination as? AddCategoryLimitViewController
            destination?.categoryName = selectedCategory
        } else if segue.identifier == "toEditCategory" {
            
        }
    }
    
    // SearchBar Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let text = searchText.lowercased()
            filteredSuggestedCategories = suggestedCategories.filter({ $0.lowercased().contains(text) })
            filteredCustomCategories = OverviewViewController.budget.categories.filter({ $0.name.lowercased().contains(text) })
            isSearching = true
        } else {
            filteredSuggestedCategories = suggestedCategories
            filteredCustomCategories = OverviewViewController.budget.categories
            isSearching = false
        }
        categoriesTableView.reloadData()
    }
    
    
    // MARK: TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            if section == 0 {
                return nil
            } else if section == 1 {
                return filteredCustomCategories.count > 0 ? "MY CATEGORIES" : nil
            } else if section == 2 {
                return "SUGGESTED CATEGORIES"
            }
        } else {
            if section == 0 {
                return filteredCustomCategories.count > 0 ? "MY CATEGORIES" : nil
            } else if section == 1 {
                return "SUGGESTED CATEGORIES"
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            if section == 0 {
                return 1
            } else if section == 1 {
                return filteredCustomCategories.count
            } else if section == 2 {
                return filteredSuggestedCategories.count
            }
        } else {
            if section == 0 {
                return filteredCustomCategories.count
            } else if section == 1 {
                return filteredSuggestedCategories.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = categoriesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isSearching {
            if section == 0 {
                cell.textLabel?.text = "Create \"\(categorySearchBar.text!)\""
            } else if section == 1 {
                cell.textLabel?.text = filteredCustomCategories[indexPath.row].name
                cell.detailTextLabel?.text = "$\(filteredCustomCategories[indexPath.row].limit)"
            } else if section == 2 {
                cell.textLabel?.text = filteredSuggestedCategories[indexPath.row]
            }
        } else {
            if section == 0 {
                cell.textLabel?.text = filteredCustomCategories[indexPath.row].name
                cell.detailTextLabel?.text = "$\(filteredCustomCategories[indexPath.row].limit)"
            } else if section == 1 {
                cell.textLabel?.text = filteredSuggestedCategories[indexPath.row]
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            if indexPath.section == 0 {
                selectedCategory = categorySearchBar.text
                performSegue(withIdentifier: "toCategoryLimit", sender: self)
            } else if indexPath.section == 1 {
                selectedIndex = indexPath.row
//                performSegue(withIdentifier: "toEditCategory", sender: self)
            } else if indexPath.section == 2 {
                selectedCategory = suggestedCategories[indexPath.row]
                performSegue(withIdentifier: "toCategoryLimit", sender: self)
            }
        } else {
            if indexPath.section == 0 {
                selectedIndex = indexPath.row
//                performSegue(withIdentifier: "toEditCategory", sender: self)
            } else if indexPath.section == 1 {
                selectedCategory = suggestedCategories[indexPath.row]
                performSegue(withIdentifier: "toCategoryLimit", sender: self)
            }
        }
        if isSearching {
            categorySearchBar.text = ""
            searchBar(categorySearchBar, textDidChange: "")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

