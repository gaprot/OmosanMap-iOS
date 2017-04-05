//
//  SearchOptionsGenreListViewController.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/06/02.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
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
            cell.accessoryType = .none
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.document?.folders.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let folder = self.document?.folders[indexPath.row] else {
            fatalError()
        }
        
        cell.textLabel?.text = folder.name
        cell.accessoryType = self.filter.hasFolderName(name: folder.name) ? .checkmark : .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let folder = self.document?.folders[indexPath.row],
            let cell = tableView.cellForRow(at: indexPath)
        else {
            fatalError()
        }

        if self.filter.hasFolderName(name: folder.name) {
            self.filter.removeFolderName(name: folder.name)
            cell.accessoryType = .none
        } else {
            self.filter.addFolderName(name: folder.name)
            cell.accessoryType = .checkmark
        }

        // Automatic deselection
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.genreDidChange?()
    }
}
