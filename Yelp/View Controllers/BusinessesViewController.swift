//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Girge on 10/18/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var businesses: [Business]?
    var searchParameters = SearchParameters()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UISearchBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search business"
//        searchBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        searchBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationItem.titleView = searchBar
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        search()
    }
    
    func search() {
        Business.search(with: searchParameters) { (businesses, error) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
//        cancelButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        navigationItem.setRightBarButton(cancelButton, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
//        navigationItem.setRightBarButton(nil, animated: false)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchParameters.term = searchBar.text
        searchBar.resignFirstResponder()
        search()
    }
    
    
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        cell.business = businesses?[indexPath.row]
        cell.clipsToBounds = true
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
