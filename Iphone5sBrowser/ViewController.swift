//
//  ViewController.swift
//  Iphone5sBrowser
//
//  Created by Alessio Santo on 24/09/14.
//  Copyright (c) 2014 alessiosanto. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIWebViewDelegate{
                            
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var imageView: UIImageView!
    
    var chosenImageIndex = 0
    let imageArray = ["iphone-wireframe.png", "iphone-black.png", "iphone-white.png"]
    
    var currentWebApp: WebApplication = WebApplication()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let secretagent = "Mozilla/5.0 (iPhone; CPU iPhone OS 7_0_6 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B651 Safari/9537.53";
        let dictionary = NSDictionary(object: secretagent, forKey: "UserAgent")
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)

        webView.scalesPageToFit = true
        
        webView.hidden = true
        
//        webView.scrollView.scrollEnabled = false;
//        webView.scrollView.bounces = false;
        
        // Do any additional setup after loading the view, typically from a nib.
        let stringUrl = "http://alessiosantocs.github.io/"
        
        loadWebPage(stringUrl)
        
        webView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openLauncher(sender: AnyObject) {
        performSegueWithIdentifier("openLauncher", sender: self)
    }
    
    @IBAction func changePhoneTheme(sender: AnyObject) {
        
        chosenImageIndex += 1
        var randomImagePath = imageArray[chosenImageIndex]
        var image = UIImage(named: randomImagePath)
        imageView.image = image
        
        if chosenImageIndex + 1 >= imageArray.count {
            chosenImageIndex = -1
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        println("ViewController => webViewDidFinishLoad")
        
        
        
        webView.hidden = false
        
        let js =
        "var meta = document.createElement('meta'); " +
        "meta.setAttribute( 'name', 'viewport' ); " +
        "meta.setAttribute( 'content', 'width = \(webView.frame.width), initial-scale = 0.8, user-scalable = no' ); " +
        "document.getElementsByTagName('head')[0].appendChild(meta);"
        
        webView.stringByEvaluatingJavaScriptFromString(js)
        
        if let pageTitle = webView?.stringByEvaluatingJavaScriptFromString("document.title;")?{
            currentWebApp.title = pageTitle
        }
        
    }
    
    
    /// Loads the string url in input into the webview
    func loadWebPage(url: String) {
        println("loading web page")
        let nsUrl = NSURL(string: url)
        let request = NSURLRequest(URL: nsUrl!)
        
        webView.hidden = true
        
        webView.loadRequest(request)

    }
    
    func setCurrentWebApp(webApp: WebApplication){
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // When preparing for the segue, have viewController1 provide a closure for
        // onDataAvailable
        if let navigationController = segue.destinationViewController as? UINavigationController {
            if let viewController = navigationController.viewControllers[0] as? LauncherViewController{
                viewController.onDataAvailable = {[weak self]
                    (data) in
                    if let weakSelf = self {
                        
                        weakSelf.currentWebApp = data as WebApplication
                        
                        let webapp = weakSelf.currentWebApp as WebApplication
                        
                        weakSelf.loadWebPage(webapp.url)
                        
                    }
                }
            }
            
        }
    }
    
    
    // MARK: - Core data
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

