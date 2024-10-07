//
//  CategoryHeader.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//
import Foundation
import UIKit

class CategoryHeader: UICollectionReusableView {
    
    static let identifier = "CategoryHeader"
    
    private let categoryImageView = UIImageView()
    private let titleLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        categoryImageView.contentMode = .scaleAspectFit
        addSubview(categoryImageView)

        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(named: "chevron.down")
        categoryImageView.contentMode = .scaleAspectFit
        addSubview(arrowImageView)

        NSLayoutConstraint.activate([
         
            categoryImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            categoryImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            categoryImageView.heightAnchor.constraint(equalToConstant: 22),
            categoryImageView.widthAnchor.constraint(equalToConstant: 22),

            titleLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 7),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            arrowImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String,
                   isVisible: Bool,
                   sportId: String,
                   numberOfEvents: Int,
                   themeService: ThemeService) {
        
        self.backgroundColor = UIColor(themeService.selectedTheme.sectionsHeaderColor)
        
        if isVisible {
            titleLabel.text = title
        } else {
            titleLabel.text = title + " (\(numberOfEvents) events)"
        }
        
        categoryImageView.image = UIImage(named: SportsCategory.getIconNameFor(sportId: sportId))
        categoryImageView.tintColor = UIColor(themeService.getTintColor(sportId: sportId))

        titleLabel.textColor = UIColor(themeService.selectedTheme.mainTextColour)

        arrowImageView.image = UIImage(systemName: isVisible ? "chevron.up" : "chevron.down" )
        arrowImageView.tintColor = UIColor(themeService.selectedTheme.mainTextColour)

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.arrowImageView.transform = CGAffineTransformMakeRotation(isVisible ? 0.0 : CGFloat(180 * Double.pi))
            self.arrowImageView.layoutSubviews()
        }) { (succeed) -> Void in }
        
    }
    
}

