//
//  LauncherController.swift
//  Iphone5sBrowser
//
//  Created by Alessio Santo on 24/09/14.
//  Copyright (c) 2014 alessiosanto. All rights reserved.
//

import UIKit

class LauncherViewController: UITableViewController{
    
    var onDataAvailable : ((data: String) -> ())?
    
    func sendData(data: String) {
        // Whenever you want to send data back to viewController1, check
        // if the closure is implemented and then call it if it is
        self.onDataAvailable?(data: data)
    }

    
    var toolbar = UIToolbar()
    var newUrlTextField = UITextField()
    var plusButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: nil, action: nil)

    let websitesArray = [
        ("Cinnamon Onboarding", "https://marvelapp.com/331b3i"),
        ("Cinnamon Prototype", "https://marvelapp.com/21ffe1"),
        ("Cinnamon Plant growth", "http://198.101.226.110/snaphealth-prototype/app.html"),
        ("Magnetiq", "http://alessiosantocs.github.io/Magnetiq")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("loaded")
        
        var mainScreenSize = UIScreen.mainScreen()
//        toolbar.layer.bounds.width = 200
        
        
        
//        toolbar.frame = CGRectMake(0, mainScreenSize.bounds.height - 44, mainScreenSize.bounds.width, 44)
//        
//        newUrlTextField.frame = CGRectMake(0, 0, mainScreenSize.bounds.width - 50, 30)
//        newUrlTextField.borderStyle = UITextBorderStyle.RoundedRect
//        newUrlTextField.backgroundColor = UIColor.whiteColor()
//        newUrlTextField.placeholder = "Insert a new page to be saved"
//        
//        var textFieldButtonItem = UIBarButtonItem(customView: newUrlTextField)
//        
//        textFieldButtonItem.width = mainScreenSize.bounds.width - 70
//        
//        
//        toolbar.items = [textFieldButtonItem, plusButton]
//        self.view.addSubview(toolbar)

        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        
    }
    
    @IBAction func cancelActionButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return websitesArray.count
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        cell.textLabel.text = websitesArray[indexPath.row].0 + " - " +  websitesArray[indexPath.row].1
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var chosenWebsite = websitesArray[indexPath.row].1
        sendData(chosenWebsite)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
