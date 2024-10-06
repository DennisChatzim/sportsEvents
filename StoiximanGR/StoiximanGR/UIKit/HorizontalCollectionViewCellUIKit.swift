//
//  EventCellUIKit.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//
import Foundation
import UIKit

// MARK: - Horizontal Collection View Cell
class HorizontalCollectionViewCell: UICollectionViewCell {
    static let identifier = "HorizontalCollectionViewCell"
    
    var themeService: ThemeService?
    var dataManager: DataManager?
    var timerManager: TimerManager?
    var itemSelected: ((SportsEvent) -> Void)?
    
    private var events: [SportsEvent] = []
    
    var disposeBag: DisposeBagForCombine = []
    
    private let innerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // Inner collection scrolls horizontally
        layout.minimumLineSpacing = 15       // Space between cells
        layout.minimumInteritemSpacing = 15  // Space between items in a row
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(innerCollectionView)
        innerCollectionView.delegate = self
        innerCollectionView.dataSource = self
        innerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            innerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            innerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            innerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            innerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        innerCollectionView.register(EventCell.self, forCellWithReuseIdentifier: EventCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: SportsCategory,
                   themeService: ThemeService,
                   dataManager: DataManager,
                   timerManager: TimerManager,
                   itemSelected: @escaping ((SportsEvent) -> Void)) {
        
        disposeBag.dispose()
        
        self.themeService = themeService
        self.dataManager = dataManager
        self.timerManager = timerManager
        self.itemSelected = itemSelected
        
        self.contentView.backgroundColor = UIColor(themeService.selectedTheme.mainBGColor)
        self.innerCollectionView.backgroundColor = UIColor(themeService.selectedTheme.mainBGColor)

        dataManager.getEventsOfThisCategory(sportsId: category.sportId)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newEventsOfThisCategory in
                guard let instance = self else { return }
                instance.events = newEventsOfThisCategory
                self?.innerCollectionView.performBatchUpdates({
                    instance.innerCollectionView.reloadSections(IndexSet(integer: 0))
                }, completion: nil)
            })
            .store(in: &disposeBag)

    }
}

// MARK: - DataSource and Delegate for Horizontal Collection View
extension HorizontalCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCell.identifier, for: indexPath) as! EventCell
        let event = events[indexPath.item]
        cell.configure(with: event,
                       dataManager: dataManager,
                       themeService: themeService,
                       timerManager: timerManager)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 4.0 - 10, height: 142)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // Inset for horizontal collection view
    }
    
//    // Handle item selection
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedEvent = events[indexPath.item]
//        print("Selected event: \(selectedEvent)")
//        // Perform any additional actions when the item is selected
//    }
}
