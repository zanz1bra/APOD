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
        view.backgroundColor = UIColor(red: 52/255.0, green: 136/255.0, blue: 153/255.0, alpha: 1.0)
        
        if let apod = apod {
            let titleLabel = UILabel()
            titleLabel.text = apod.title
            titleLabel.font = UIFont(name: "Futura", size: 20)
            titleLabel.textColor = .white
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(titleLabel)
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.cornerRadius = 13.0
            view.addSubview(imageView)
            
            if let imageURL = URL(string: apod.imageUrl!) {
                imageView.sd_setImage(with: imageURL, completed: nil)
            }
            
            let explanationTextView = UITextView()
            explanationTextView.text = apod.explanation
            explanationTextView.font = UIFont(name: "Futura", size: 15)
            explanationTextView.textColor = UIColor(red: 242/255.0, green: 235/255.0, blue: 199/255.0, alpha: 1.0)
            explanationTextView.translatesAutoresizingMaskIntoConstraints = false
            explanationTextView.isEditable = false
            explanationTextView.isScrollEnabled = true
            explanationTextView.backgroundColor = UIColor(red: 52/255.0, green: 136/255.0, blue: 153/255.0, alpha: 1.0)
            explanationTextView.textAlignment = .justified
            view.addSubview(explanationTextView)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                
                imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                imageView.heightAnchor.constraint(equalToConstant: 200), 
                
                explanationTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                explanationTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                explanationTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                explanationTextView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
                explanationTextView.heightAnchor.constraint(equalToConstant: 300)
            ])
        }
    }
}
