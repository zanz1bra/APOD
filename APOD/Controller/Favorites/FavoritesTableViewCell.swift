//
//  FavoritesTableViewCell.swift
//  APOD
//
//  Created by erika.talberga on 28/11/2023.
//

import UIKit
import SDWebImage

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
        label.font = UIFont.systemFont(ofSize: 8)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 12)
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
            customImageView.widthAnchor.constraint(equalToConstant: 50), 
            customImageView.heightAnchor.constraint(equalTo: customImageView.widthAnchor, multiplier: 1.0),
        ])
        
        // Set up constraints for the stack view
        NSLayoutConstraint.activate([
            textStackView.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            textStackView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
//            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with favorite: FavoriteAPOD) {
        if let imageUrl = favorite.imageUrl, let url = URL(string: imageUrl) {
            customImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "circle.and.line.horizontal.fill"))
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let inputDate = dateFormatter.date(from: favorite.date!) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = dateFormatter.string(from: inputDate)
            dateLabel.text = formattedDate
        }
        
        titleLabel.text = favorite.title
        
        print("Favorite Title: \(favorite.title ?? "No title")")
        print("Favorite Date: \(favorite.date ?? "No date")")
    }
}
