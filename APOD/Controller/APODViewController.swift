//
//  ViewController.swift
//  APOD
//
//  Created by erika.talberga on 27/11/2023.
//

import UIKit
import SDWebImage

class APODViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        fetchAPOD()
    }
    
    func setupView() {
        title = "Astronomy Picture of the Day"
        view.backgroundColor = .systemPurple
        navigationController?.navigationBar.tintColor = .label
        
        // Add scrollView
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemCyan
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Set scrollView constraints
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // Add a vertical stack view
        let stackView = UIStackView()
        stackView.backgroundColor = .systemYellow
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Add imageView to the stack view
        stackView.addArrangedSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        // Add explanationTextView to the stack view
        stackView.addArrangedSubview(explanationTextView)
        explanationTextView.isScrollEnabled = false // Allow the textView to expand based on content
        
        // Set stack view constraints
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
    }
    
    
    func fetchAPOD() {
        NetworkManager.fetchData(url: NetworkManager.api) {
            apod in
            DispatchQueue.main.async {
                self.updateUI(with: apod)
            }
        }
    }
    
    func updateUI(with apod: APOD) {
        imageView.image = nil
        
        if let imageUrl = URL(string: apod.url) {
            print("Image URL: \(imageUrl)")
            imageView.sd_setImage(with: imageUrl) { (image, error, cacheType, url) in
                if let error = error {
                    print("Error loading image: \(error.localizedDescription)")
                }}
        }
        print("url.apod")
        
        
        explanationTextView.text = apod.explanation
    }
    
}


