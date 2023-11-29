//
//  FavoritesDetailViewController.swift
//  APOD
//
//  Created by erika.talberga on 29/11/2023.
//

import UIKit
import SDWebImage

class FavoritesDetailViewController: UIViewController {
    
    var apod: FavoriteAPOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if let apod = apod {
            let titleLabel = UILabel()
            titleLabel.text = apod.title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
            titleLabel.textColor = .black
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(titleLabel)
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            
            if let imageURL = URL(string: apod.imageUrl!) {
                imageView.sd_setImage(with: imageURL, completed: nil)
            }
            
            let explanationTextView = UITextView()
            explanationTextView.text = apod.explanation
            explanationTextView.font = UIFont.systemFont(ofSize: 10)
            explanationTextView.textColor = .black
            explanationTextView.translatesAutoresizingMaskIntoConstraints = false
            explanationTextView.isEditable = false
            explanationTextView.isScrollEnabled = true
            view.addSubview(explanationTextView)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                
                imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                imageView.heightAnchor.constraint(equalToConstant: 200), // Adjust the height as needed
                
                explanationTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                explanationTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                explanationTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                explanationTextView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                explanationTextView.heightAnchor.constraint(equalToConstant: 300)
            ])
        }
    }
}
