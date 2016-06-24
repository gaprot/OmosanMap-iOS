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

        LocationService.shared.start()
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
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        self.performSegueWithIdentifier("Detail", sender: nil)
//    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegueWithIdentifier("Detail", sender: nil)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // 自分の現在位置を表すアノテーションは除く
        if annotation === mapView.userLocation {
            return nil
        }
        
        let identifier = "Pin"
        let annotationView =
            mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.annotation = annotation
        annotationView.image = UIImage(named: "pin")
        
        // アノテーションをタップしたら「吹き出し」を表示
        // annotationのtitleとsubtitle、rightCalloutAccessoryViewが表示される
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        
        return annotationView
    }
}

extension MapViewController: SearchOptionsControllerDelegate {
    func searchOptionsController(controller: SearchOptionsController, didChangeFilter: DocumentDataSource.Filter) {
        self.updateTitle()
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
                self?.updateTitle()
                self?.updateMap()
                self?.searchButton.enabled = true
            }
        }
    }

    
    func updateTitle() {
        if let folderNames = self.filter.folderNames {
            self.navigationItem.title = folderNames.joinWithSeparator(",")
        } else {
            self.navigationItem.title = "すべて"
        }
    }
    
    func updateMap() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let placemarks = DocumentDataSource.shared.placemarksForFilter(self.filter)
        for placemark in placemarks {
            let annotation = MKPointAnnotation()
            annotation.title = placemark.name
            annotation.subtitle = placemark.sanitizedDescriptionText
            annotation.coordinate = placemark.coordinate
            self.mapView.addAnnotation(annotation)
        }
//        let annotation = MKPointAnnotation()
//        annotation.title = "東京スカイツリー"
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 35.710359, longitude: 139.810722)
//        self.mapView.addAnnotation(annotation)
        
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}
