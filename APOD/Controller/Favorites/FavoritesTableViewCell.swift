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
        return imageView
    }()
    
    let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Futura", size: 10)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Futura", size: 13)
        label.numberOfLines = 0
        return label
    } ()
    
    let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
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
        contentView.addSubview(separatorLine)
        
        textStackView.addArrangedSubview(dateLabel)
        textStackView.addArrangedSubview(titleLabel)
        
        customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        customImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        customImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        customImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        textStackView.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 8).isActive = true
        textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
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

    }
}
