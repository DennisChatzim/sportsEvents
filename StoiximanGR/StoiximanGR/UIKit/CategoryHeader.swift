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
    private let gradient = CAGradientLayer()

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
        
        let startPoint : CGPoint = CGPoint(x: 0.5, y: 0.0)
        let endPoint : CGPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)

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
                   theme: Theme) {

        self.backgroundColor = UIColor(theme.sectionsHeaderColor)
        
        if isVisible {
            titleLabel.text = title
        } else {
            titleLabel.text = title + " (\(numberOfEvents) events)"
        }
        
        categoryImageView.image = UIImage(named: SportsCategory.getIconNameFor(sportId: sportId))
        categoryImageView.tintColor = UIColor(theme.getTintColor(sportId: sportId))
        titleLabel.textColor = UIColor(theme.mainTextColour)
        arrowImageView.image = UIImage(systemName: isVisible ? "chevron.up" : "chevron.down" )
        arrowImageView.tintColor = UIColor(theme.mainTextColour)
        gradient.colors = [UIColor(theme.sectionsHeaderColor).cgColor, UIColor(theme.mainBGColor).cgColor]

        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.arrowImageView.transform = CGAffineTransformMakeRotation(isVisible ? 0.0 : CGFloat(180 * Double.pi))
            self.arrowImageView.layoutSubviews()
        }) { (succeed) -> Void in }
        
    }
    
}

