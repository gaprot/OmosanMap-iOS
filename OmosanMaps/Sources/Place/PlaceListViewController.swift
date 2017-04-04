//
//  PlaceListViewController.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/02/17.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import UIKit
import AlamofireImage

class PlaceListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    lazy private var dataSource: DocumentDataSource = DocumentDataSource()
    private var document: Document? {
        return self.dataSource.document
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: once
        self.fetchData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch (identifier) {
        case "showDetail":
            // 詳細画面へ
            guard
                let cell = sender as? UITableViewCell,
                let indexPath = self.tableView.indexPath(for: cell),
                let placemark = self.placemarkAtIndexPath(indexPath: indexPath),
                let placeDetailVC = segue.destination as? PlaceDetailViewController
            else {
                return			// TODO
            }

            placeDetailVC.placemark = placemark
        default:
            break
        }
    }

// MARK: - UITableViewDataSource, UITableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.document?.folders.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.document?.folders[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let folder = self.document?.folders[section] else {
            return 0
        }
        
        return folder.placemarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let placemark = self.placemarkAtIndexPath(indexPath: indexPath) else {
            abort()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = placemark.name
        cell.detailTextLabel?.text = placemark.descriptionText
        if let imageURL = placemark.imageURLs.first {
            let placeholderImage = UIImage(named: "placeholder")
            cell.imageView?.af_setImage(withURL: imageURL, placeholderImage: placeholderImage)
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
// MARK: - private

    private func fetchData() {
        let sourceURLString = "https://www.google.com/maps/d/u/0/kml?mid=zmkzjAlquG4s.k9j-gW9GbmCQ"
        self.dataSource.fetch(URLString: sourceURLString) { (error) -> Void in
            if let error = error {
                print(error)
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    private func folderAtSection(section: Int) -> Folder? {
        return self.document?.folders[section]
    }
    
    private func placemarkAtIndexPath(indexPath: IndexPath) -> Placemark? {
        guard let folder = self.folderAtSection(section: indexPath.section) else {
            return nil
        }
        
        return folder.placemarks[indexPath.row]
    }
}
