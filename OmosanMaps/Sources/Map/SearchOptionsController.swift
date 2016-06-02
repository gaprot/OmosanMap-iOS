//
//  SearchOptionsController.swift
//  OmosanMaps
//
//  Created by yuichi.kobayashi on 2016/06/02.
//  Copyright © 2016年 *. All rights reserved.
//

import UIKit

class SearchOptions {
    var genres: [String]?
}

class SearchOptionsController: UITableViewController {

    var filter: DocumentDataSource.Filter!
    weak var delegate: SearchOptionsControllerDelegate?
    
    @IBOutlet weak var genreNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateGenreNameLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Genre" {
            guard let searchOptionsGenreListViewController = segue.destinationViewController as? SearchOptionsGenreListViewController else {
                return
            }
            
            searchOptionsGenreListViewController.filter = self.filter
            searchOptionsGenreListViewController.genreDidChange = { [weak self] in
                self?.handleGenreDidChange()
            }
        }
    }
}

private extension SearchOptionsController {
    func handleGenreDidChange() {
        self.updateGenreNameLabel()
        self.delegate?.searchOptionsController(self, didChangeFilter: self.filter)
    }
    
    func updateGenreNameLabel() {
        if let folderNames = self.filter.folderNames {
            self.genreNameLabel.text = folderNames.joinWithSeparator(", ")
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
