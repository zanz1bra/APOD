//
//  ViewController.swift
//  APOD
//
//  Created by erika.talberga on 27/11/2023.
//

import UIKit
import SDWebImage
import CoreData

class APODViewController: UIViewController {
    
    var currentAPOD: APOD?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let explanationTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Futura", size: 15)
        textView.textAlignment = .justified
        textView.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        textView.textColor = UIColor(red: 242/255.0, green: 235/255.0, blue: 199/255.0, alpha: 1.0)
        return textView
    }()
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Futura", size: 20)
        textView.textAlignment = .justified
        textView.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        textView.textColor = .white
        return textView
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont(name: "Futura", size: 13)
        dateLabel.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        dateLabel.textColor = UIColor(red: 242/255.0, green: 235/255.0, blue: 199/255.0, alpha: 1.0)
        return dateLabel
    }()
    
    private let copyrightTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Futura", size: 12)
        textView.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        textView.textColor = UIColor(red: 242/255.0, green: 235/255.0, blue: 199/255.0, alpha: 1.0)
        return textView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchAPOD()
        setupTabBarItem()
    }
    
    //MARK: - Setup View
    
    func setupView() {
        title = "Astronomy Picture of the Day"

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(activityIndicator)
        activityIndicator.startAnimating()

        stackView.addArrangedSubview(imageView)
        imageView.contentMode = .scaleAspectFit
    
        stackView.addArrangedSubview(titleTextView)
        titleTextView.isScrollEnabled = false
        
        stackView.addArrangedSubview(dateLabel)
        
        stackView.addArrangedSubview(copyrightTextView)
        copyrightTextView.isScrollEnabled = false

        stackView.addArrangedSubview(explanationTextView)
        explanationTextView.isScrollEnabled = false
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        
        setupFavoriteButton()
    }
    
    func setupTabBarItem() {
        let apodTabBarItem = UITabBarItem(title: "APOD", image: UIImage(systemName: "photo.fill"), selectedImage: nil)
        self.tabBarItem = apodTabBarItem
    }

    
    //MARK: - Fetching data
    
    func fetchAPOD() {
        NetworkManager.fetchData(url: NetworkManager.api) {
            apod in
            DispatchQueue.main.async {
                self.updateUI(with: apod)
            }
        }
    }
    
    //MARK: - Update UI after fetching data
    
    func updateUI(with apod: APOD) {
        currentAPOD = apod
        
        activityIndicator.startAnimating()
        
        if let imageUrl = URL(string: apod.url) {
            print("Image URL: \(imageUrl)")
            imageView.sd_setImage(with: imageUrl, placeholderImage: nil, options: .continueInBackground, completed: { (image, error, cacheType, url) in
                self.activityIndicator.stopAnimating()
                
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                }
            })
        }
        
        imageView.image = nil
        
        if let imageUrl = URL(string: apod.url) {
            print("Image URL: \(imageUrl)")
            imageView.sd_setImage(with: imageUrl) { (image, error, cacheType, url) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                }
                
            }
            
        }
        
        titleTextView.text = apod.title
        
//        Format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let inputDate = dateFormatter.date(from: apod.date) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = dateFormatter.string(from: inputDate)
            dateLabel.text =  formattedDate
        }
        
        if apod.copyright != nil {
            let trimmedCopyright = apod.copyright?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let replacedNewlines = trimmedCopyright.replacingOccurrences(of: "\r\n", with: " ").replacingOccurrences(of: "\n", with: " ")
            copyrightTextView.text = replacedNewlines
        } else {
            copyrightTextView.text = "No copyright information available"
        }
   
        explanationTextView.text = apod.explanation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToTop()
    }
    
    func scrollToTop() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
    }
    
    //MARK: - Core Data
    
    func setupFavoriteButton() {
        let favoriteButton = UIButton()
        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        favoriteButton.backgroundColor = UIColor(red: 52/255.0, green: 54/255.0, blue: 66/255.0, alpha: 1.0)
        favoriteButton.setTitleColor(UIColor(red: 252/255.0, green: 255/255.0, blue: 245/255.0, alpha: 1.0), for: .normal)
        favoriteButton.layer.cornerRadius = 13.0
        stackView.addArrangedSubview(favoriteButton)
    }
    
    @objc func addToFavorites() {
        guard let currentAPOD = currentAPOD else {
            print("Error: currentAPOD is nil.")
            return
        }

        if CoreDataManager.shared.checkIfFavorite(date: currentAPOD.date) {
            showAlreadyInFavoritesAlert()
        } else {
            CoreDataManager.shared.saveToCoreData(apod: currentAPOD)
            NotificationCenter.default.post(name: .didAddToFavorites, object: nil)
            showAddedToFavorites()
        }
    }
    
    func showAddedToFavorites() {
        let alertController = UIAlertController(title: "Added to Favorites", message: "This APOD has been added to favorites", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlreadyInFavoritesAlert() {
        let alertController = UIAlertController(
            title: "Already in Favorites",
            message: "This picture is already in your favorites.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: - Notification Center

extension Notification.Name {
    static let didAddToFavorites = Notification.Name("DidAddToFavorites")
}


