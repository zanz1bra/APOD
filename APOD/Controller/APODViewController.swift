//
//  ViewController.swift
//  APOD
//
//  Created by erika.talberga on 27/11/2023.
//

import UIKit
import SDWebImage

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
        return textView
    }()
    
    private let dateLabel: UILabel = UILabel()
    private let copyrightLabel: UILabel = UILabel()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setupView()
        fetchAPOD()
        setupTabBarItem()
    }
    
    //MARK: - Setup View
    
    func setupView() {
        title = "Astronomy Picture of the Day"
        view.backgroundColor = .systemPurple
        navigationController?.navigationBar.tintColor = .label
        
        // Add scrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        
        // Add imageView to the stack view
        stackView.addArrangedSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
//        Add dateLabel to stack view
        stackView.addArrangedSubview(dateLabel)
        
//        Add copyrightLabel to stack view
        stackView.addArrangedSubview(copyrightLabel)
        
        // Add explanationTextView to the stack view
        stackView.addArrangedSubview(explanationTextView)
        explanationTextView.isScrollEnabled = false // Allow the textView to expand based on content
        
        // Set stack view constraints
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        
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
        
        imageView.image = nil
        
        if let imageUrl = URL(string: apod.url) {
            print("Image URL: \(imageUrl)")
            imageView.sd_setImage(with: imageUrl) { (image, error, cacheType, url) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
            
        }
        print("url.apod")
        
//        Format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        if let inputDate = dateFormatter.date(from: apod.date) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = dateFormatter.string(from: inputDate)
            dateLabel.text =  formattedDate
        }
        
        copyrightLabel.text = apod.copyright.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Copyright Label :\(apod.copyright)")
        
        explanationTextView.text = apod.explanation
    }
    
    //MARK: - Core Data
    
    func setupFavoriteButton() {
        let favoriteButton = UIButton()
        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        stackView.addArrangedSubview(favoriteButton)
    }
    
    @objc func addToFavorites() {
        if let currentAPOD = currentAPOD {
            CoreDataManager.shared.saveToCoreData(apod: currentAPOD)
        } else {
            print("Error: currentAPOD is nil.")
        }
    }
    
}




