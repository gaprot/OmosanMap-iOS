//
//  PlaceDetailViewController.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/02/22.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import UIKit
import MapKit

class PlaceDetailViewController: UIViewController {
    var placemark: Placemark?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.update()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func showActions(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Safariで検索", style: .Default) { (action) in
            self.searchInSafari()
        })
        actionSheet.addAction(UIAlertAction(title: "マップで開く", style: .Default) { (action) in
            self.openInMap()
        })
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
}

private extension PlaceDetailViewController {
    private func update()
    {
        guard let placemark = self.placemark else {
            return
        }
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        self.mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegionMakeWithDistance(
            placemark.coordinate,
            200,
            200
        )
        self.mapView.region = region
        
        self.navigationItem.title = placemark.name
        
        if
            let descriptionTextData = placemark.descriptionText.dataUsingEncoding(NSUnicodeStringEncoding),
            let attributedDescriptionText = try? NSAttributedString(
                data: descriptionTextData,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil
            ) {
            self.descriptionTextView.attributedText = attributedDescriptionText
        }
    }
    
    /**
     Safariで検索.
     */
    private func searchInSafari() {
        guard
            let placemark = self.placemark,
            let url = NSURL(string: "x-web-search://?\(placemark.name.encodingToURIRepresentation())")
            else {
                return
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
    
    /**
     マップで開く.
     */
    private func openInMap() {
        guard
            let placemark = self.placemark,
            let url = NSURL(string: "https://maps.apple.com/?ll=\(placemark.coordinate.latitude),\(placemark.coordinate.longitude)&q=\(placemark.name.encodingToURIRepresentation())")
        else {
            return
        }
        
        UIApplication.sharedApplication().openURL(url)
    }
}

private extension String {
    /**
     URLで使用できる文字にエスケープする.
     
     - returns: エスケープされた文字列を返す.
     */
    func encodingToURIRepresentation() -> String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!
    }
}
