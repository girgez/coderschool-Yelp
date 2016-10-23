//
//  FilterViewController.swift
//  Yelp
//
//  Created by Girge on 10/20/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import UIKit

@objc protocol FilterViewControllerDelegate {
    func filter(_ filterViewController: FilterViewController)
}

class FilterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FilterViewControllerDelegate!
    var filter: SearchParameters!
    var distanceExtend = false
    var sortModeExtend = false
    var categoryExtend = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func search(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) { 
            self.delegate.filter(self)
        }
    }
}

extension FilterViewController: SwitchCellDelegate, ExtendCellDelegate, CheckCellDelegate, LabelCellDelagate {
    func switchCell(_ value: Any, identifier: String) {
        if identifier == "deals" {
            filter.deals = value as? Bool
        }
    }
    
    func labelCell(cell: LabelCell) {
        categoryExtend = true
        tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
    }
    
    func extendCell(cell: ExtendCell) {
        switch tableView.indexPath(for: cell)!.section {
        case 1:
            distanceExtend = true
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        case 2:
            sortModeExtend = true
            tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        default:
            break
        }
    }
    
    func checkCell(cell: CheckCell) {
        let indexPath = tableView.indexPath(for: cell)!
        switch indexPath.section {
        case 1:
            filter.distance = cell.nameLabel.text!
            distanceExtend = false
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        case 2:
            filter.sortMode = YelpSortMode(rawValue: indexPath.row)!
            sortModeExtend = false
            tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        case 3:
            let code = Constant.categories[indexPath.row]["code"]!
            if filter.categories.contains(code) {
                filter.categories.remove(at: filter.categories.index(of: code)!)
            } else {
                filter.categories.append(code)
            }
            cell.checkView.isHidden = !cell.checkView.isHidden
        default:
            break
        }
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return distanceExtend ? Constant.distance.count : 1
        case 2:
            return sortModeExtend ? Constant.sortMode.count : 1
        case 3:
            return categoryExtend ? Constant.categories.count : 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Distance"
        case 2:
            return "Sort By"
        case 3:
            return "Categories"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.identifier = "deals"
            cell.nameLabel.text = "Offering a Deal"
            cell.switchButton.setOn(filter.deals ?? false, animated: false)
            cell.delegate = self
            return cell
        case 1:
            if distanceExtend {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell") as! CheckCell
                cell.nameLabel.text = Constant.distance[indexPath.row]
                cell.checkView.isHidden = filter.distance != Constant.distance[indexPath.row]
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExtendCell") as! ExtendCell
                cell.nameLabel.text = filter.distance
                cell.delegate = self
                return cell
            }
        case 2:
            if sortModeExtend {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell") as! CheckCell
                cell.nameLabel.text = Constant.sortMode[indexPath.row]
                cell.checkView.isHidden = filter.sortMode.hashValue != indexPath.row
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExtendCell") as! ExtendCell
                cell.nameLabel.text = Constant.sortMode[filter.sortMode.hashValue]
                cell.delegate = self
                return cell
            }
        case 3:
            if !categoryExtend && indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! LabelCell
                cell.delegate = self
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell") as! CheckCell
            let category = Constant.categories[indexPath.row]
            cell.nameLabel.text = category["name"]
            cell.checkView.isHidden = !filter.categories.contains(category["code"]!)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1 {
//            if distanceExtend {
//                filter.distance = Constant.distance[indexPath.row]
//            }
//            distanceExtend = !distanceExtend
//            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
//        }
//    }
}
