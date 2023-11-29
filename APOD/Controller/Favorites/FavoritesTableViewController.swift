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

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FavoritesTableViewCell
        let favorite = favorites[indexPath.row]
        
        cell.configure(with: favorite)

        return cell
    }
    
//    MARK: - Navigation to detail view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]

        let detailViewController = FavoritesDetailViewController()
        detailViewController.apod = favorite

        // Present the DetailViewController modally
        present(detailViewController, animated: true, completion: nil)
    }
    
//    MARK: - Deleting item from Favorites and Core Data
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteAlert(at: indexPath)
        }
    }
    
    func showDeleteAlert(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Favorite", message: "Are you sure you want to delete this favorite?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.deleteFavorite(at: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
//    MARK: - Core Data methods
    func fetchAndDisplayFavorites() {
        favorites = CoreDataManager.shared.fetchFavorites()
        tableView.reloadData()
    }
    
    func addToFavorites(apod: APOD) {
        CoreDataManager.shared.saveToCoreData(apod: apod)
        fetchAndDisplayFavorites()
    }
    
    func deleteFavorite(at indexPath: IndexPath) {
        let favorite = favorites.remove(at: indexPath.row)
        CoreDataManager.shared.deleteFavorite(apod: favorite)
    }

}
