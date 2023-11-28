//
//  FavoritesTableViewController.swift
//  APOD
//
//  Created by erika.talberga on 28/11/2023.
//

import UIKit
import CoreData
import SDWebImage

class FavoritesTableViewController: UITableViewController {
    
    var favorites: [FavoriteAPOD] = []
    let cellID = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: cellID)
        fetchAndDisplayFavorites()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FavoritesTableViewCell
        let favorite = favorites[indexPath.row]
        
        if let imageUrl = favorite.imageUrl, let url = URL(string: imageUrl) {
            cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(systemName: "circle.and.line.horizontal.fill"))
        }
        cell.textLabel?.text = favorite.title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    func fetchAndDisplayFavorites() {
        favorites = CoreDataManager.shared.fetchFavorites()
        tableView.reloadData()
    }
    
    func addToFavorites(apod: APOD) {
        CoreDataManager.shared.saveToCoreData(apod: apod)
        fetchAndDisplayFavorites()
    }
    
    func deleteFavorite(at indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        CoreDataManager.shared.deleteFavorite(apod: favorite)
        fetchAndDisplayFavorites()
    }

}
