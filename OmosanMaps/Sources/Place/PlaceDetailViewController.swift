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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.update()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showActions(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Safariで検索", style: .default) { (action) in
            self.searchInSafari()
        })
        actionSheet.addAction(UIAlertAction(title: "マップで開く", style: .default) { (action) in
            self.openInMap()
        })
        
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}

fileprivate extension PlaceDetailViewController {
    fileprivate func update() {
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
            let descriptionTextData = placemark.descriptionText.data(using: String.Encoding.unicode),
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
    fileprivate func searchInSafari() {
        guard
            let placemark = self.placemark,
            let url = URL(string: "x-web-search://?\(placemark.name.encodingToURIRepresentation())")
            else {
                return
        }
        
        UIApplication.shared.openURL(url)
    }
    
    /**
     マップで開く.
     */
    fileprivate func openInMap() {
        guard
            let placemark = self.placemark,
            let url = URL(string: "https://maps.apple.com/?ll=\(placemark.coordinate.latitude),\(placemark.coordinate.longitude)&q=\(placemark.name.encodingToURIRepresentation())")
        else {
            return
        }
        
        UIApplication.shared.openURL(url)
    }
}

private extension String {
    /**
     URLで使用できる文字にエスケープする.
     
     - returns: エスケープされた文字列を返す.
     */
    func encodingToURIRepresentation() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
    }
}
