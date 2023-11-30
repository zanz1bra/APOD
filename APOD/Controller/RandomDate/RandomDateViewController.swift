//
//  RandomDateViewController.swift
//  APOD
//
//  Created by erika.talberga on 30/11/2023.
//

import UIKit
import SDWebImage
import CoreData

class RandomDateViewController: UIViewController {
    
    var randomAPOD: APOD?
    
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
    
    private let titleLabel: UILabel = UILabel()
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
        setupView()
        fetchAPOD()
    }
    
    func setupView() {
        
//        let buttonContainerView = UIView()
//        buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(buttonContainerView)
//        
//        buttonContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        buttonContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        buttonContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let refreshButton = UIButton()
        refreshButton.setTitle("New picture", for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(refreshButton)

        refreshButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
//        let favoriteButton = UIButton()
//        favoriteButton.setTitle("Add to Favorites", for: .normal)
//        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
//        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
//        buttonContainerView.addSubview(favoriteButton)
//        
//        favoriteButton.leadingAnchor.constraint(equalTo: refreshButton.trailingAnchor, constant: 8).isActive = true
//        favoriteButton.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor, constant: -16).isActive = true
//        favoriteButton.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor, constant: -8).isActive = true
//        favoriteButton.widthAnchor.constraint(equalTo: refreshButton.widthAnchor).isActive = true
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 8).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(copyrightLabel)
        
        stackView.addArrangedSubview(explanationTextView)
        explanationTextView.isScrollEnabled = false
        
        // Set stack view constraints
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        
        setupFavoriteButton()
    }
    
    //    MARK: - Fetching data
    
    func fetchAPOD() {
        NetworkManager.fetchData(url: NetworkManager.api) {
            apod in
            DispatchQueue.main.async {
                self.updateUI(with: apod)
            }
        }
    }
    
    func fetchRandomAPOD() {
        NetworkManager.fetchRandomDate { randomAPOD in
            DispatchQueue.main.async {
                self.updateUI(with: randomAPOD)
            }
        }
    }
    

    //    MARK: - Update UI after fetching data
    
    func updateUI(with apod: APOD) {
        randomAPOD = apod
        
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
        
        titleLabel.text = apod.title
        
        //        Format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let inputDate = dateFormatter.date(from: apod.date) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = dateFormatter.string(from: inputDate)
            dateLabel.text =  formattedDate
        }
        
        if apod.copyright != nil {
            copyrightLabel.text = apod.copyright?.trimmingCharacters(in: .whitespacesAndNewlines)
            print("Copyright Label :\(String(describing: apod.copyright))")
        } else {
            copyrightLabel.text = "No copyright information available"
        }
        
        explanationTextView.text = apod.explanation
        
    }
    
    //    MARK: - Adding to Favorites
    func setupFavoriteButton() {
        let favoriteButton = UIButton()
        favoriteButton.setTitle("Add to Favorites", for: .normal)
        favoriteButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        stackView.addArrangedSubview(favoriteButton)
    }
    
    @objc func addToFavorites() {
        if let randomAPOD = randomAPOD {
            CoreDataManager.shared.saveToCoreData(apod: randomAPOD)
        } else {
            print("Error: randomAPOD is nil.")
        }
    }
    
    
    //MARK: - Fetching random APOD
    @objc func refreshButtonTapped() {
        fetchRandomAPOD()
        print("Refresh button tapped")
    }
    
}
