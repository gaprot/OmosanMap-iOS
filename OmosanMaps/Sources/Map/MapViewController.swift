//
//  MapViewController.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2016/05/27.
//  Copyright © 2016年 *. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    private var filter: DocumentDataSource.Filter = DocumentDataSource.Filter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Search" {
            let destinationVC = segue.destinationViewController
            destinationVC.popoverPresentationController?.delegate = self
            
            guard
                let navigationController = segue.destinationViewController as? UINavigationController,
                let searchOptionsController = navigationController.topViewController as? SearchOptionsController
            else {
                return
            }
            
            searchOptionsController.filter = self.filter
            searchOptionsController.delegate = self
        } else if segue.identifier == "Detail" {
            guard
                let placeDetailVC = segue.destinationViewController as? PlaceDetailViewController,
                let coordinate = self.mapView.selectedAnnotations.first?.coordinate,
                let placemark = DocumentDataSource.shared.placemarksForCoordinate(coordinate).first
            else {
                return
            }
            
            placeDetailVC.placemark = placemark
        }
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        self.performSegueWithIdentifier("Detail", sender: nil)
    }
}

extension MapViewController: SearchOptionsControllerDelegate {
    func searchOptionsController(controller: SearchOptionsController, didChangeFilter: DocumentDataSource.Filter) {
        self.updateMap()
    }
}

private extension MapViewController {
    func loadData() {
        let sourceURLString = "https://www.google.com/maps/d/u/0/kml?mid=zmkzjAlquG4s.k9j-gW9GbmCQ"
        DocumentDataSource.shared.fetch(sourceURLString) { [weak self] (error) in
            if let error = error {
                print(error)
            } else {
                self?.updateMap()
                self?.searchButton.enabled = true
            }
        }
    }

    func updateMap() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let placemarks = DocumentDataSource.shared.placemarksForFilter(self.filter)
        for placemark in placemarks {
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            self.mapView.addAnnotation(annotation)
        }
        
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}
