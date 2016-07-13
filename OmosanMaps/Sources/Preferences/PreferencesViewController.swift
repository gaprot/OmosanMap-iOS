//
//  PreferencesViewController.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2016/07/13.
//  Copyright © 2016年 *. All rights reserved.
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
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PreferencesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        Defaults[.kmlURL] = textField.text
        NSNotificationCenter.defaultCenter().postNotificationName(KMLURLDidChangeNotification, object: nil)
        
        textField.resignFirstResponder()
        
        return true
    }
}
