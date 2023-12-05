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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    } ()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 13.0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchRandomAPOD()
    }
    
//    MARK: - Setting up view
    
    func setupView() {
        
        title = "Random Date"
        view.backgroundColor = .systemGray
        navigationController?.navigationBar.tintColor = UIColor(red: 209/255.0, green: 219/255.0, blue: 189/255.0, alpha: 1.0)

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
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
        
        let refreshButton = UIButton()
        refreshButton.setTitle("New picture", for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        refreshButton.backgroundColor = UIColor(red: 52/255.0, green: 54/255.0, blue: 66/255.0, alpha: 1.0)
        refreshButton.setTitleColor(UIColor(red: 252/255.0, green: 255/255.0, blue: 245/255.0, alpha: 1.0), for: .normal)
        refreshButton.layer.cornerRadius = 13.0
        stackView.addArrangedSubview(refreshButton)
        
        
    }

    
    //    MARK: - Fetching data
    
    func fetchRandomAPOD() {
        NetworkManager.fetchRandomDate { randomAPOD in
            DispatchQueue.main.async {
                self.updateUI(with: randomAPOD)
                self.scrollToTop()
            }
        }
    }
    
    func scrollToTop() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
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
    

    
    //    MARK: - Adding to Favorites
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
        guard let randomAPOD = randomAPOD else {
            print("Error: currentAPOD is nil.")
            return
        }

        if CoreDataManager.shared.checkIfFavorite(date: randomAPOD.date) {
            showAlreadyInFavoritesAlert()
        } else {
            CoreDataManager.shared.saveToCoreData(apod: randomAPOD)
            NotificationCenter.default.post(name: .didAddToFavorites, object: nil)
        }
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
    
    
    //MARK: - Fetching random APOD
    @objc func refreshButtonTapped() {
        fetchRandomAPOD()
        print("Refresh button tapped")
    }
    
}

extension Notification.Name {
    static let didAddRandomDateToFavorites = Notification.Name("DidAddRandomDateToFavorites")
}
