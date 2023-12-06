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
        textView.textAlignment = .justified
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
        fetchSpecificDateAPOD()
    }
    
//    MARK: - Setting up view
    
    func setupView() {

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
        
        let datePickerButton = UIButton()
        datePickerButton.setTitle("Choose A New Date", for: .normal)
        datePickerButton.addTarget(self, action: #selector(datePickerButtonTapped), for: .touchUpInside)
        datePickerButton.backgroundColor = UIColor(red: 52/255.0, green: 54/255.0, blue: 66/255.0, alpha: 1.0)
        datePickerButton.setTitleColor(UIColor(red: 252/255.0, green: 255/255.0, blue: 245/255.0, alpha: 1.0), for: .normal)
        datePickerButton.layer.cornerRadius = 13.0
        
        stackView.addArrangedSubview(datePickerButton)

    }
    
    @objc func datePickerButtonTapped() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        let currentDate = Date()
        datePicker.maximumDate = currentDate
        
        let lastDate = Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 20)) ?? Date()
        datePicker.minimumDate = lastDate
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let pickerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: alertController.view.frame.width - 20, height: 200))
        pickerContainerView.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerXAnchor.constraint(equalTo: pickerContainerView.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: pickerContainerView.centerYAnchor).isActive = true
        
        alertController.view.addSubview(pickerContainerView)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            let selectedDate = datePicker.date
            self.fetchSpecificDateAPOD(date: self.formattedDate(selectedDate))
        }
        
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
    
    func fetchSpecificDateAPOD(date: String? = nil) {
        var url = NetworkManager.api
        
        if let selectedDate = date {
            url += "&date=\(selectedDate)"
        }
        
        NetworkManager.fetchData(url: url) { apod in
            DispatchQueue.main.async {
                self.updateUI(with: apod)
                self.scrollToTop()
            }
        }
    }
    
    func scrollToTop() {
        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
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
        
        titleTextView.text = apod.title
        
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
        guard let specificDateAPOD = specificDateAPOD else {
            print("Error: currentAPOD is nil.")
            return
        }

        if CoreDataManager.shared.checkIfFavorite(date: specificDateAPOD.date) {
            showAlreadyInFavoritesAlert()
        } else {
            CoreDataManager.shared.saveToCoreData(apod: specificDateAPOD)
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


extension Notification.Name {
    static let didAddSpecificDateToFavorites = Notification.Name("DidAddSpecificDateToFavorites")
}
