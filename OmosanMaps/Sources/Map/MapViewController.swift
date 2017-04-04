//
//  MapViewController.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/05/27.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage
import SwiftyUserDefaults

class MapViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    fileprivate var filter: DocumentDataSource.Filter = DocumentDataSource.Filter()
    fileprivate let imageDownloader = ImageDownloader()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(kmlURLDidChange), name: NSNotification.Name(rawValue: KMLURLDidChangeNotification), object: nil)
        
        LocationService.shared.start()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search" {
            let destinationVC = segue.destination
            destinationVC.popoverPresentationController?.delegate = self
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let searchOptionsController = navigationController.topViewController as? SearchOptionsController
            else {
                return
            }
            
            searchOptionsController.filter = self.filter
            searchOptionsController.delegate = self
        } else if segue.identifier == "Detail" {
            guard
                let placeDetailVC = segue.destination as? PlaceDetailViewController,
                let coordinate = self.mapView.selectedAnnotations.first?.coordinate,
                let placemark = DocumentDataSource.shared.placemarksForCoordinate(coordinate: coordinate).first
            else {
                return
            }
            
            placeDetailVC.placemark = placemark
        }
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func kmlURLDidChange(notification: NSNotification) {
        DocumentDataSource.shared.clear()
        self.filter = DocumentDataSource.Filter()
    }
}

extension MapViewController: MKMapViewDelegate {
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        self.performSegueWithIdentifier("Detail", sender: nil)
//    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 自分の現在位置を表すアノテーションは除く
        if annotation === mapView.userLocation {
            return nil
        }
        guard let placemarkAnnotation = annotation as? PlacemarkAnnotation else {
            fatalError()
        }
        let styleID = placemarkAnnotation.styleID
        
        let identifier = "Pin"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.annotation = annotation

        let defaultIconImage = UIImage(named: "pin")
        if let iconURL = DocumentDataSource.shared.iconURL(for: styleID) {

            self.imageDownloader.download(URLRequest(url: iconURL)) { response in
                switch response.result {
                case .success(var image):
                    if let color = DocumentDataSource.shared.iconColor(for: styleID) {
                        image = image.filteringColor(color: color)
                    }
                    annotationView.image = image
                case .failure(_):
                    annotationView.image = defaultIconImage
                }
            }
        } else {
            annotationView.image = defaultIconImage
        }
        
        // アノテーションをタップしたら「吹き出し」を表示
        // annotationのtitleとsubtitle、rightCalloutAccessoryViewが表示される
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return annotationView
    }
}

extension MapViewController: SearchOptionsControllerDelegate {
    func searchOptionsController(controller: SearchOptionsController, didChangeFilter: DocumentDataSource.Filter) {
        self.updateTitle()
        self.updateMap()
    }
}

extension MapViewController {
    func loadData() {
        if DocumentDataSource.shared.hasDocument {
            return
        }
        
        //let sourceURLString = "https://www.google.com/maps/d/u/0/kml?mid=zmkzjAlquG4s.k9j-gW9GbmCQ"
        guard let sourceURLString = Defaults[.kmlURL] else {
            self.alertInvalidURL()
            return
        }
        
        DocumentDataSource.shared.fetch(URLString: sourceURLString) { [weak self] (error) in
            if let error = error as? NSError {
                if error.domain == NSURLErrorDomain {
                    self?.alertInvalidURL()
                } else {
                    print(error)
                }
            } else {
                self?.updateTitle()
                self?.updateMap()
                self?.searchButton.isEnabled = true
            }
        }
    }

    
    func updateTitle() {
        if let folderNames = self.filter.folderNames {
            self.navigationItem.title = folderNames.joined(separator: ",")
        } else {
            self.navigationItem.title = "すべて"
        }
    }
    
    func updateMap() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let placemarks = DocumentDataSource.shared.placemarksForFilter(filter: self.filter)
        for placemark in placemarks {
            let annotation = PlacemarkAnnotation(placemark: placemark)
            self.mapView.addAnnotation(annotation)
        }
//        let annotation = MKPointAnnotation()
//        annotation.title = "東京スカイツリー"
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 35.710359, longitude: 139.810722)
//        self.mapView.addAnnotation(annotation)
        
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    private func alertInvalidURL() {
        let alert = UIAlertController(
            title: "読み込みエラー",
            message: "地図データを読み込めませんでした。正しいURLを設定してください。",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "設定", style: .default) { (action) in
            self.performSegue(withIdentifier: "Preferences", sender: self)
            }
        )
        
        self.present(alert, animated: true, completion: nil)
    }
}
