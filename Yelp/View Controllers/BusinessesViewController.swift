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
    var isLoadingMore = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search business"
        navigationItem.titleView = searchBar
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        search()
    }
    
    func loadMore() {
        Business.search(with: searchParameters) { (businesses, error) in
            if businesses != nil && businesses!.count > 0 {
                self.businesses! += businesses!
                self.searchParameters.offset += 20
            }
            self.isLoadingMore = false
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func search() {
        ProgressHUD.show()
        searchParameters.offset = 0
        Business.search(with: searchParameters) { (businesses, error) in
            self.businesses = businesses
            self.tableView.reloadData()
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)
            }
            self.searchParameters.offset = 20
            ProgressHUD.dismiss()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Filter" {
            let nc = segue.destination as! UINavigationController
            let filterController = nc.topViewController as! FilterViewController
            filterController.filter = searchParameters.clone()
            filterController.delegate = self
        }
    }
}

extension BusinessesViewController: FilterViewControllerDelegate {
    func filter(_ filterViewController: FilterViewController) {
        self.searchParameters = filterViewController.filter
        search()
    }
//    func filter(_ searchParameters: SearchParameters) {
////        self.searchParameters = searchParameters
//        search()
//    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
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

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isLoadingMore) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isLoadingMore = true
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMore()
            }
        }
        
    }
    
    
}
