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
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
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
        styleCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        styleCell()
    }
    
    private func setupViews() {
        contentView.addSubview(customImageView)
        contentView.addSubview(textStackView)
        
        textStackView.addArrangedSubview(dateLabel)
        textStackView.addArrangedSubview(titleLabel)
        
        customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        customImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        customImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        customImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textStackView.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 8).isActive = true
        textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
    }
    
    func styleCell() {
        contentView.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        
        dateLabel.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        dateLabel.textColor = UIColor(red: 242/255.0, green: 235/255.0, blue: 199/255.0, alpha: 1.0)
        
        titleLabel.backgroundColor = UIColor(red: 62/255.0, green: 96/255.0, blue: 111/255.0, alpha: 1.0)
        titleLabel.textColor = UIColor(red: 242/255.0, green: 235/255.0, blue: 199/255.0, alpha: 1.0)
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
