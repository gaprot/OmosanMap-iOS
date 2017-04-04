//
//  PreferencesViewController.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/07/13.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

let KMLURLDidChangeNotification: String = "KMLURLDidChangeNotification"

class PreferencesViewController: UITableViewController {

    @IBOutlet weak var kmlURLTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.kmlURLTextField.text = Defaults[.kmlURL]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PreferencesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        Defaults[.kmlURL] = textField.text
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: KMLURLDidChangeNotification), object: nil)
        
        textField.resignFirstResponder()
        
        return true
    }
}
