//
//  ViewController.swift
//  Iphone5sBrowser
//
//  Created by Alessio Santo on 24/09/14.
//  Copyright (c) 2014 alessiosanto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate{
                            
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var imageView: UIImageView!
    
    var chosenImageIndex = 0
    let imageArray = ["iphone-wireframe.png", "iphone-black.png", "iphone-white.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let secretagent = "Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X; en-us) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53";
        let dictionary = NSDictionary(object: secretagent, forKey: "UserAgent")
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)

        webView.scalesPageToFit = false
        
        webView.hidden = true
        
        webView.scrollView.scrollEnabled = false;
        webView.scrollView.bounces = false;
        
        // Do any additional setup after loading the view, typically from a nib.
//        let stringUrl = "https://marvelapp.com/331b3i"
        let stringUrl = "https://marvelapp.com/21ffe1"
//        let stringUrl = "http://198.101.226.110/snaphealth-prototype/app.html"
        
        let url = NSURL.URLWithString(stringUrl)
        let request = NSURLRequest(URL: url)
        
        webView.loadRequest(request)
        
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        webView.hidden = false
        
        let js =
        "var meta = document.createElement('meta'); " +
        "meta.setAttribute( 'name', 'viewport' ); " +
        "meta.setAttribute( 'content', 'width = 270, initial-scale = 1.0, user-scalable = no' ); " +
        "document.getElementsByTagName('head')[0].appendChild(meta)"
        
        webView.stringByEvaluatingJavaScriptFromString(js)
    }
}

