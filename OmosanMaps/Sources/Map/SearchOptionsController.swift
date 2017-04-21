//
//  SearchOptionsController.swift
//  OmosanMaps
//
//  Created by Gaprot Dev Team on 2016/06/02.
//  Copyright © 2016年 Up-frontier, Inc. All rights reserved.
//

import UIKit

class SearchOptions {
    var genres: [String]?
}

class SearchOptionsController: UITableViewController {
    var filter: DocumentDataSource.Filter!
    weak var delegate: SearchOptionsControllerDelegate?
    
    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var rangeSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateGenreNameLabel()
        self.rangeSegmentedControl.selectedSegmentIndex = filter.region?.rawValue ?? 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Genre" {
            guard let searchOptionsGenreListViewController = segue.destination as? SearchOptionsGenreListViewController else {
                return
            }
            
            searchOptionsGenreListViewController.filter = self.filter
            searchOptionsGenreListViewController.genreDidChange = { [weak self] in
                self?.handleGenreDidChange()
            }
        }
    }
    
    @IBAction func rangeDidChange(sender: UISegmentedControl) {
        guard
            let region = DocumentDataSource.Filter.Region(rawValue: sender.selectedSegmentIndex),
            let location = LocationService.shared.lastLocation
        else {
            return
        }

        self.filter.baseLocation = location
        self.filter.region = region

        self.delegate?.searchOptionsController(controller: self, didChangeFilter: self.filter)
    }
}

private extension SearchOptionsController {
    func handleGenreDidChange() {
        self.updateGenreNameLabel()
        self.delegate?.searchOptionsController(controller: self, didChangeFilter: self.filter)
    }
    
    func updateGenreNameLabel() {
        if let folderNames = self.filter.folderNames {
            self.genreNameLabel.text = folderNames.joined(separator: ", ")
        } else {
            self.genreNameLabel.text = "すべて"
        }
    }
}

// MARK - SearchOptionsControllerDelegate

protocol SearchOptionsControllerDelegate: class {
    func searchOptionsController(controller: SearchOptionsController, didChangeFilter: DocumentDataSource.Filter)
}

extension SearchOptionsControllerDelegate {
    func searchOptionsController(controller: SearchOptionsController, didChangeFilter: DocumentDataSource.Filter) {
    }
}
