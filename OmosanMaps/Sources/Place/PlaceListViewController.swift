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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: once
        self.fetchData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch (identifier) {
        case "showDetail":
            // 詳細画面へ
            guard
                let cell = sender as? UITableViewCell,
                let indexPath = self.tableView.indexPathForCell(cell),
                let placemark = self.placemarkAtIndexPath(indexPath),
                let placeDetailVC = segue.destinationViewController as? PlaceDetailViewController
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.document?.folders[section].name
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let folder = self.document?.folders[section] else {
            return 0
        }
        
        return folder.placemarks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let placemark = self.placemarkAtIndexPath(indexPath) else {
            abort()
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = placemark.name
        cell.detailTextLabel?.text = placemark.descriptionText
        if let imageURL = placemark.imageURLs.first {
            let placeholderImage = UIImage(named: "placeholder")
            cell.imageView?.af_setImageWithURL(imageURL, placeholderImage: placeholderImage)
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
// MARK: - private

    private func fetchData() {
        let sourceURLString = "https://www.google.com/maps/d/u/0/kml?mid=zmkzjAlquG4s.k9j-gW9GbmCQ"
        self.dataSource.fetch(sourceURLString) { (error) -> Void in
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
    
    private func placemarkAtIndexPath(indexPath: NSIndexPath) -> Placemark? {
        guard let folder = self.folderAtSection(indexPath.section) else {
            return nil
        }
        
        return folder.placemarks[indexPath.row]
    }
}
