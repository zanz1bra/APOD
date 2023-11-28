//
//  FavoritesTableViewCell.swift
//  APOD
//
//  Created by erika.talberga on 28/11/2023.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(customImageView)
        contentView.addSubview(textStackView)
        
        textStackView.addArrangedSubview(dateLabel)
        textStackView.addArrangedSubview(titleLabel)
        
        // Set up constraints for the image view
        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            customImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            customImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 4) // Adjust the multiplier to make the image smaller
        ])
        
        // Set up constraints for the stack view
        NSLayoutConstraint.activate([
            textStackView.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
