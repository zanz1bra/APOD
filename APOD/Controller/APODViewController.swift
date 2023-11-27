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
        imageView.contentMode = .scaleAspectFit
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
        
        // Add imageView
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        //        Add descriptionView
        view.addSubview(explanationTextView)
        explanationTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        explanationTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        explanationTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        explanationTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
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
        
        if let imageUrl = URL(string: apod.hdurl) {
            imageView.sd_setImage(with: imageUrl) {_, _, _, _ in }
        }
        explanationTextView.text = apod.explanation
    }
    
    
}

