//
//  EventCellUIKit.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//
import Foundation
import UIKit
import Combine

class EventCellUIKit: UICollectionViewCell {
    
    static let identifier = "EventCell"

    private let remainingTimeLabel = UILabel()
    private let titleLabel = UILabel()
    private let favoriteIcon = UIImageView()
    
    var timer: Timer?
    var event: SportsEvent?
    var dataManager: DataManager?
    var disposeBag: DisposeBagForCombine = []
    var timerManager: TimerManager?
    
    @objc private func didTapFavouriteIcon(_ sender: UITapGestureRecognizer) {
                
        guard let event = event,
        let dataManager = dataManager else {
            debugPrint("event or dataManager are not set. Can't update Favourite setting ?")
            return
        }
        
        dataManager.setThisEventFavourite(eventID: event.eventId,
                                          sportId: event.sportId)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        favoriteIcon.image = UIImage(systemName: "star")
        favoriteIcon.isUserInteractionEnabled = true
        favoriteIcon.translatesAutoresizingMaskIntoConstraints = false
        favoriteIcon.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapFavouriteIcon(_:)))
        favoriteIcon.addGestureRecognizer(tapGesture)
        contentView.addSubview(favoriteIcon)
        
        remainingTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        remainingTimeLabel.numberOfLines = 1
        remainingTimeLabel.textAlignment = .center
        contentView.addSubview(remainingTimeLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            remainingTimeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            remainingTimeLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 13.0),
            remainingTimeLabel.widthAnchor.constraint(equalToConstant: getEventCellWidth() * 0.8),
            remainingTimeLabel.heightAnchor.constraint(equalToConstant: 28)
        ])

        NSLayoutConstraint.activate([
            favoriteIcon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            favoriteIcon.topAnchor.constraint(equalTo: remainingTimeLabel.bottomAnchor, constant: 8),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 28),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: favoriteIcon.bottomAnchor, constant: 5),
            titleLabel.widthAnchor.constraint(equalToConstant: getEventCellWidth()),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with event: SportsEvent,
                   dataManager: DataManager?,
                   themeService: ThemeService?,
                   timerManager: TimerManager?) {
                
        self.event = event
        self.dataManager = dataManager
        self.timerManager = timerManager
        
        remainingTimeLabel.layer.borderColor = UIColor(themeService?.selectedTheme.customTextColour ?? .blue).cgColor
        remainingTimeLabel.layer.borderWidth = 1
        remainingTimeLabel.layer.cornerRadius = 6
        
        titleLabel.text = event.eventName
        favoriteIcon.image = UIImage(systemName: event.isFavourite ? "star.fill" : "star")

        disposeBag.dispose() // This is very important -> It will improve memory performance while reusing cells and also fix duplicated data issues !

        timerManager?.$currentDateUIKit
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newDate in
                guard let instance = self else { return }
                instance.remainingTimeLabel.text = instance.event?.timeRemainingInDaysHoursMinutesSeconds(currentDate: newDate)
            })
            .store(in: &disposeBag)
        
        guard let themeService = themeService else {
            debugPrint("Error: themeService not set in EventCell") // This normally never will happen
            return
        }

        remainingTimeLabel.textColor = UIColor(themeService.selectedTheme.mainTextColour)
        titleLabel.textColor = UIColor(themeService.selectedTheme.mainTextColour)
        favoriteIcon.tintColor = event.isFavourite ? UIColor(themeService.selectedTheme.favouriteActiveColour) : UIColor(themeService.selectedTheme.favouriteInactiveColour)
        
        remainingTimeLabel.text = event.timeRemainingInDaysHoursMinutesSeconds(currentDate: Date())
        
    }
    
}
