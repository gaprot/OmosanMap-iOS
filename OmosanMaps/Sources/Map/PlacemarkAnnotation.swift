//
//  PlacemarkAnnotation.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2016/07/07.
//  Copyright © 2016年 *. All rights reserved.
//

import UIKit
import MapKit

class PlacemarkAnnotation: MKPointAnnotation {
    let styleID: String
    
    init(placemark: Placemark) {
        self.styleID = placemark.styleID
        
        super.init()
        
        self.title = placemark.name
        self.subtitle = placemark.sanitizedDescriptionText
        self.coordinate = placemark.coordinate
    }
}
