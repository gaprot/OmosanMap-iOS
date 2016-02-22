//
//  PlaceDetailViewController.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2016/02/22.
//  Copyright © 2016年 *. All rights reserved.
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
}
