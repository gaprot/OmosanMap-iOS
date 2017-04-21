//
//  LocationService.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/06/24.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    static let shared = LocationService()
    
    private var locationManager = CLLocationManager()
    fileprivate(set) var lastLocation: CLLocation?
    fileprivate var startedAt: NSDate!
    
    private override init() {
        super.init()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.delegate = self
    }

    @available(iOS 9.0, *)
    func requestOnce() {
        self.locationManager.requestLocation()
    }
    
    func start() {
        self.locationManager.startUpdatingLocation()
        self.startedAt = NSDate()
    }
    
    func stop() {
        self.locationManager.stopUpdatingLocation()
        self.startedAt = nil
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        if location.timestamp.timeIntervalSince1970 < self.startedAt.timeIntervalSince1970 {
            return		// キャッシュされた古い位置情報
        }
        
        self.lastLocation = location
        //print("location: \(location)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}
