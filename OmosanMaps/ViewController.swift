//
//  ViewController.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2015/10/06.
//  Copyright (c) 2015年 *. All rights reserved.
//

import UIKit
import Alamofire
import SSZipArchive

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loadData(sender: AnyObject) {
        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        var localURL: NSURL?
        Alamofire
            .download(
                .GET,
                "https://www.google.com/maps/d/u/0/kml?mid=zmkzjAlquG4s.k9j-gW9GbmCQ",
                destination: { (temporaryURL, response) in
                    let pathComponent = response.suggestedFilename
            
                    localURL = directoryURL.URLByAppendingPathComponent(pathComponent!)
                    return localURL!
        }).response{ (request, response, data, error) in
            if let localPath = localURL?.path {
                let kmlDirPath = localPath.stringByReplacingOccurrencesOfString(".kmz", withString: "")
                if SSZipArchive.unzipFileAtPath(localPath, toDestination: kmlDirPath) {
                    let kmlPath = kmlDirPath.stringByAppendingString("/doc.kml")
                    if let kml = try? String(contentsOfFile: kmlPath, encoding: NSUTF8StringEncoding) {
                        print(kml)
                    }
                }
            }
        }
    }
}

