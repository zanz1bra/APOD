//
//  DatePickerViewController.swift
//  APOD
//
//  Created by erika.talberga on 02/12/2023.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    var completionHandler: ((Date) -> Void)?
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        return picker
    }()
    
    init(completionHandler: ((Date) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.completionHandler = completionHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func doneButtonTapped() {
        let formattedDate = formattedDate(datePicker.date)
        let apiUrl = "\(NetworkManager.api)&date=\(formattedDate)"
        print("API URL: \(apiUrl)")
        
        completionHandler?(datePicker.date)
        
        // Print debug information
        print("Is being presented: \(isBeingPresented)")
        print("Is being dismissed: \(isBeingDismissed)")
        print("Navigation Controller: \(String(describing: navigationController))")
        
        // Create an instance of SpecificDateViewController
        let specificDateViewController = SpecificDateViewController()
        
        // Set the date to be displayed in SpecificDateViewController
        specificDateViewController.fetchSpecificDateAPOD(date: formattedDate)
        
        // Push the SpecificDateViewController onto the navigation stack
        navigationController?.pushViewController(specificDateViewController, animated: true)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
