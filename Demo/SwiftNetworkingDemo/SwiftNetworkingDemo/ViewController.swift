//
//  ViewController.swift
//  SwiftNetworkingDemo
//
//  Created by jins on 14/10/31.
//  Copyright (c) 2014年 BlackWater. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let manager = SessionManager(sessionConfiguration: <#NSURLSessionConfiguration#>)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(NSURL(string: "https://api.douban.com/v2/album/71575659/photos")!) {
            data, response, error
            in
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
            println(json)
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

