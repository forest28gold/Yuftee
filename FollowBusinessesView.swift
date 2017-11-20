//
//  FollowBusinessesViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 04/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

class FollowBusinessesViewController : NavPageViewController {
    
    var businessesInSearch = [BusinessesSearchResult]()
    
    @IBOutlet weak var searchBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    
    var addBusiness = AddBusinessViewController(nibName: "AddBusinessView", bundle: nil)
    var myBusinesses = MyBusinessesViewController(nibName: "MyBusinesses", bundle: nil)
    
    var showingBusinesses = true
    
    var tapGesture: UITapGestureRecognizer?
    
    var rFtopTabley : CGFloat = 0
    var rFtopy : CGFloat = 0
    var rFtopW : CGFloat = 0
    var bSearchT : Bool = false
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = ""
        
        self.btnBack.hidden = true;
        self.addChildViewController(myBusinesses)
        self.view.addSubview(myBusinesses.view)
        
        searchBox.text = ""

        showingBusinesses = true;
        
        self.tableView.hidden = true
        
        myBusinesses.view.frame = CGRect(x: -10, y: self.view.bounds.height - 310, width: self.view.bounds.width + 20, height: 310)
        
        self.tableView.frame = CGRect(x: -10, y: self.view.bounds.height - 310, width: self.view.bounds.width + 20, height: 310)
        
        rFtopy = myBusinesses.view.frame.origin.y
        rFtopTabley = self.tableView.frame.origin.y
        
        myBusinesses.view.backgroundColor = UIColor.clearColor()
        
        myBusinesses.view.layer.shadowOpacity = 0.3
        
        myBusinesses.navDelegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        tapGesture?.cancelsTouchesInView = false
        tapGesture!.delegate = self
        view.addGestureRecognizer(tapGesture!)
        
        bSearchT = false
        
        
      
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func hideKeyboard () {
        self.searchBox.resignFirstResponder()
    }
    
    @IBAction func clickedBack(sender: AnyObject) {
        searchBox.text = ""
        searchTextChanged(searchBox)
    }
    
    @IBAction func clickedSearch(sender: AnyObject) {
        
        self.bSearchT = true
 //       self.tableView.hidden = true
//        self.tableView.frame = CGRect(x: -10, y: self.view.bounds.height + 10, width: self.view.bounds.width + 20, height: 310)

 //       self.myBusinesses.view.frame = CGRect(x: -10, y: self.rFtopy, width: self.view.bounds.width + 20, height: self.view.bounds.height - self.rFtopy)
//        
//        if (showingBusinesses || searchBox.text == "") {
//            
//        }
//        else{
//            self.filterContentForSearchText(searchBox.text)
//            tableView.reloadData()
//
//            myBusinesses.loadCollectionData()
//        }
    }
    
    func toggleResultsTable () {
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {

            if self.showingBusinesses {
                self.myBusinesses.view.frame = CGRect(x: -10, y: self.view.bounds.height + 10, width: self.view.bounds.width + 20, height: self.view.bounds.height - self.rFtopy)
            } else {
                self.myBusinesses.view.frame = CGRect(x: -10, y: self.rFtopy, width: self.view.bounds.width + 20, height: self.view.bounds.height - self.rFtopy)
            }

            if self.showingBusinesses {
                self.tableView.hidden = false
//                self.tableView.frame = CGRect(x: -10, y: self.view.bounds.height - 310, width: self.view.bounds.width + 20, height: 310)
            } else {
                self.tableView.hidden = true
            }
            
            self.showingBusinesses = !self.showingBusinesses

            
            
        }, completion: { (animted: Bool) in
            
        })
        
    }
    
    @IBAction func searchTextChanged(sender: UITextField) {
    
        if (showingBusinesses || sender.text == "") {
            toggleResultsTable()
        }
        
        self.filterContentForSearchText(sender.text)
        tableView.reloadData()
    
    }
    
    func filterContentForSearchText(searchText: String) {
        BusinessSearch.sharedInstance.getBusinessNamesFromSearch(searchText, results: { results in
            self.businessesInSearch = results
            self.tableView.reloadData()
        })
    }
}

// MARK - UIGestureRecognizerDelegate
extension FollowBusinessesViewController: UIGestureRecognizerDelegate {
    
}

// MARK - UITableViewDataSource
extension FollowBusinessesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessesInSearch.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: Reuse cell
        
        
        var cell = UITableViewCell()
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.text = businessesInSearch[indexPath.row].name
        
        if self.bSearchT {
            let selectedBusinessId = businessesInSearch[indexPath.row].id
            BusinessSearch.sharedInstance.fetchBusinessDetails(selectedBusinessId) { businessToAdd in
                println(businessToAdd)
                
                User.sharedInstance.isFollowing(selectedBusinessId) { isFollowing in
                    self.addBusiness.setBusiness(business: businessToAdd, isFollowing: isFollowing)
                    if isFollowing{
                        User.sharedInstance.followBusiness(businessToAdd.id)
                    }
                    
                }
                
            }
            
        }
        
        
        
        return cell
    }
    
}

// MARK - UITableViewDelegate
extension FollowBusinessesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("selected")
        
        let selectedBusinessId = businessesInSearch[indexPath.row].id
        BusinessSearch.sharedInstance.fetchBusinessDetails(selectedBusinessId) { businessToAdd in
            println(businessToAdd)
            User.sharedInstance.isFollowing(selectedBusinessId) { isFollowing in
                self.addBusiness.setBusiness(business: businessToAdd, isFollowing: isFollowing)
                self.navigationController?.pushViewController(self.addBusiness, animated: true)
            }
            
        }
    }
}

// MARK - NavDelegate
extension FollowBusinessesViewController: NavDelegate {
    
    func goToPage(page: Page) {
        hideKeyboard()
        navDelegate?.goToPage(page)
    }
    
}
