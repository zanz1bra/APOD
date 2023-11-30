//
//  SpecificDateViewController.swift
//  APOD
//
//  Created by erika.talberga on 30/11/2023.
//

import UIKit
import SDWebImage
import CoreData

class SpecificDateViewController: UIViewController {
    
    var specificDateAPOD: APOD?
    
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
        fetchSpecificDateAPOD(date: "2000-11-11")
    }
    
//    MARK: - Setting up view
    
    func setupView() {
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
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
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
        
        setupFavoriteButton()
        
        let datePickerButton = UIButton()
        datePickerButton.setTitle("Choose Date", for: .normal)
        datePickerButton.addTarget(self, action: #selector(datePickerButtonTapped), for: .touchUpInside)
        datePickerButton.backgroundColor = .black
        stackView.addArrangedSubview(datePickerButton)

    }
    
    @objc func datePickerButtonTapped() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        let lastDate = Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 20)) ?? Date()
        datePicker.minimumDate = lastDate
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            let selectedDate = datePicker.date
            self.fetchSpecificDateAPOD(date: self.formattedDate(selectedDate))
        }
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(datePicker)
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
//    MARK: - Fetching data
    
    func fetchSpecificDateAPOD(date: String) {
        NetworkManager.fetchData(url: "\(NetworkManager.api)&date=\(date)") { apod in
            DispatchQueue.main.async {
                self.updateUI(with: apod)
            }
        }
    }
    
//    MARK: - Update UI
    
    func updateUI(with apod: APOD) {
        specificDateAPOD = apod
        imageView.image = nil
        
        if let imageUrl = URL(string: apod.url) {
            imageView.sd_setImage(with: imageUrl) { (image, error, cacheType, url) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }
        
        titleLabel.text = apod.title
        
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
        favoriteButton.backgroundColor = .black
        stackView.addArrangedSubview(favoriteButton)
    }
    
    @objc func addToFavorites() {
        if let specificDateAPOD = specificDateAPOD {
            CoreDataManager.shared.saveToCoreData(apod: specificDateAPOD)
        } else {
            print("Error: specificDateAPOD is nil.")
        }
    }
    
    
    
}
