//
//  LauncherController.swift
//  Iphone5sBrowser
//
//  Created by Alessio Santo on 24/09/14.
//  Copyright (c) 2014 alessiosanto. All rights reserved.
//

import UIKit
import CoreData

class LauncherViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate{
    
    var onDataAvailable : ((data: AnyObject) -> ())?
    
    func sendData(data: AnyObject) {
        // Whenever you want to send data back to viewController1, check
        // if the closure is implemented and then call it if it is
        self.onDataAvailable?(data: data)
    }

    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var actionButton: UIBarButtonItem!
    
    var toolbar = UIToolbar()
    var newUrlTextField = UITextField()
    var plusButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: nil, action: nil)

    var websitesArray: NSMutableArray = []
    var searchedWebsitesArray = []
    
    
    // The view is displayed
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Let's set the view as delegate of the search bar
        searchBar.delegate = self
        
        self.searchDisplayController?.searchResultsTableView.delegate = self
        
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.searchDisplayController?.searchResultsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
        // Fetch web apps from persistent memory
        fetchWebApps()
        
        searchBar.showsSearchResultsButton = false
        searchBar.showsScopeBar = false
        searchBar.showsCancelButton = false
        searchBar.showsBookmarkButton = false
        
    }
    
    
    @IBAction func cancelActionButton(sender: AnyObject) {
        if let title = sender.title?{
            if title == "Cancel"{
                dismissViewControllerAnimated(true, completion: nil)
            }else{
                addWebAppWithTitle("", url: searchBar.text)
            }
        }
        
        
    }
    
    func filterContentForSearchText(searchText: String){
        let predicate = NSPredicate(format: "%K contains[c] %@", "url", searchText)
        
        self.searchedWebsitesArray = websitesArray.filteredArrayUsingPredicate(predicate!)
    }

    
    /// Creates an instance of the WebApplication entity and updated the table view
    func addWebAppWithTitle(title: String, url : String){
        let testEntity = NSEntityDescription.insertNewObjectForEntityForName("WebApplication", inManagedObjectContext: self.managedObjectContext!) as WebApplication
        
        testEntity.title = title
        testEntity.url = url

        websitesArray.insertObject(testEntity, atIndex: websitesArray.count)

//        tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
        tableView.reloadData()
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        actionButton.title = "Cancel"
        
    }
    
    /// Fetches persistent WebApplications previousely added and makes a copy into the websitesArray variable
    func fetchWebApps(){
        let fetchRequest = NSFetchRequest(entityName: "WebApplication")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [WebApplication] {
            websitesArray = NSMutableArray(array: fetchResults)
        }
        
        self.managedObjectContext?.save(NSErrorPointer())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View delegate methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func realWebsitesArray() -> AnyObject{
        if actionButton.title == "Add"{
            return searchedWebsitesArray
        }else{
            return websitesArray
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            if self.searchedWebsitesArray.count == 0{
                return 1
            }else{
                return searchedWebsitesArray.count
            }
            
        } else {
            return websitesArray.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        var webApp:WebApplication
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            if self.searchedWebsitesArray.count == 0{
                cell.textLabel.text = "Add as a prototype"
            }else{
                webApp = searchedWebsitesArray[indexPath.row] as WebApplication
                cell.textLabel.text = webApp.title + " - " +  webApp.url
            }
        }else{
            webApp = websitesArray[indexPath.row] as WebApplication
            cell.textLabel.text = webApp.title + " - " +  webApp.url
        }
        
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var webApp:WebApplication
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
            if self.searchedWebsitesArray.count == 0{
                self.addWebAppWithTitle("", url: searchBar.text)
                searchBar.resignFirstResponder()
            }else{
                webApp = searchedWebsitesArray[indexPath.row] as WebApplication
                
                var chosenWebsite: WebApplication = webApp
                sendData(chosenWebsite)
                dismissViewControllerAnimated(true, completion: nil)
            }
            
        }else{
            webApp = websitesArray[indexPath.row] as WebApplication
            
            var chosenWebsite: WebApplication = webApp
            sendData(chosenWebsite)
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete && tableView != self.searchDisplayController?.searchResultsTableView{
            let webApplicationToDelete = websitesArray[indexPath.row] as WebApplication
            self.managedObjectContext?.deleteObject(webApplicationToDelete)
            self.fetchWebApps()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return false
        }else{
            return true
        }

        
    }
    
    // MARK: - Search bar delegate methods
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        println("begin editing")
        if searchBar.text == "" {
            searchBar.text = "http://"
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.searchDisplayController?.setActive(false, animated: true)
    }
    
    func searchDisplayControllerDidEndSearch(controller: UISearchDisplayController) {
        self.searchDisplayController?.setActive(false, animated: true)
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//
////        filterContentForSearchText(searchText)
//        
////        if(searchText != ""){
////            actionButton.title = "Add"
////        }else{
////            actionButton.title = "Cancel"
////        }
//        
//    }
    
    override func disablesAutomaticKeyboardDismissal() -> Bool {
        return false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    // MARK: - Core Data Stuff
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
}
