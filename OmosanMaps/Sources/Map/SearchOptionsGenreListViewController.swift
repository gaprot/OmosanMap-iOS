//
//  SearchOptionsGenreListViewController.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2016/06/02.
//  Copyright © 2016年 *. All rights reserved.
//

import UIKit

class SearchOptionsGenreListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var filter: DocumentDataSource.Filter!
    var genreDidChange: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Enable self sizing cell
        //self.tableView.estimatedRowHeight = 100    // FIXME
        //self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ジャンルの指定をクリア
    @IBAction func clear(sender: AnyObject) {
        self.filter.folderNames = nil
        for cell in self.tableView.visibleCells {
            cell.accessoryType = .None
        }
        self.genreDidChange?()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchOptionsGenreListViewController: UITableViewDataSource, UITableViewDelegate {
    private var document: Document? {
        return DocumentDataSource.shared.document
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.document?.folders.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        guard let folder = self.document?.folders[indexPath.row] else {
            fatalError()
        }
        
        cell.textLabel?.text = folder.name
        cell.accessoryType = self.filter.hasFolderName(folder.name) ? .Checkmark : .None

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard
            let folder = self.document?.folders[indexPath.row],
            let cell = tableView.cellForRowAtIndexPath(indexPath)
        else {
            fatalError()
        }

        if self.filter.hasFolderName(folder.name) {
            self.filter.removeFolderName(folder.name)
            cell.accessoryType = .None
        } else {
            self.filter.addFolderName(folder.name)
            cell.accessoryType = .Checkmark
        }

        // Automatic deselection
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.genreDidChange?()
    }
}
