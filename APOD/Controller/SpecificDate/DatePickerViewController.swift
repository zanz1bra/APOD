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
        picker.preferredDatePickerStyle = .inline
        picker.clipsToBounds = true
        picker.overrideUserInterfaceStyle = .dark
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
        
        datePicker.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.backgroundColor = UIColor(red: 52/255.0, green: 54/255.0, blue: 66/255.0, alpha: 1.0)
        doneButton.setTitleColor(UIColor(red: 252/255.0, green: 255/255.0, blue: 245/255.0, alpha: 1.0), for: .normal)
        doneButton.layer.cornerRadius = 13.0
        
        let currentDate = Date()
        datePicker.maximumDate = currentDate
        
        let lastDate = Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 20)) ?? Date()
        datePicker.minimumDate = lastDate
        
        view.addSubview(doneButton)

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    @objc private func doneButtonTapped() {
        let formattedDate = formattedDate(datePicker.date)
        let apiUrl = "\(NetworkManager.api)&date=\(formattedDate)"
        print("API URL: \(apiUrl)")
        
        completionHandler?(datePicker.date)
        
        let specificDateViewController = SpecificDateViewController()

        specificDateViewController.fetchSpecificDateAPOD(date: formattedDate)

        navigationController?.pushViewController(specificDateViewController, animated: true)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}
