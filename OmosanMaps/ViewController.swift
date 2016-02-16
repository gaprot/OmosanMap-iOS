//
//  ViewController.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2015/10/06.
//  Copyright (c) 2015年 *. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy private var dataSource: DocumentDataSource = DocumentDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadData(sender: AnyObject) {
        let sourceURLString = "https://www.google.com/maps/d/u/0/kml?mid=zmkzjAlquG4s.k9j-gW9GbmCQ"
        self.dataSource.fetch(sourceURLString) { (error) -> Void in
            print(error)
        }
    }
}

