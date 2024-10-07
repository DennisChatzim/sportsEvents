//
//  EventsUIViewController.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation
import UIKit
import Combine

class EventsUIViewController: UIViewController {
    
    // All singletons should be efined here if we had only UIkit implementation and this screen was the Root View controller of the app
    var dataManager = DataManager.shared
    var themeService = ThemeService.shared
    var timerManager = TimerManager.shared
    
    private var model = SportsViewModel(dataManager: DataManager.shared, networkManager: NetworkManager.shared)
    private var categoryVisibility: [Bool] = []
    private var disposeBag: DisposeBagForCombine = []
    
    private let refreshControl = UIRefreshControl()
    var mySpinnerView = UIView(frame: .zero)
    var backgroundView = UIView() // We need this in order to have consistent background colour behind the scrollable contant when Collection view is scolled to full bottom edge

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()
        

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()

        setUpData()
        
    }

    private func setupUI() {
        
        setNavigationBarItems()
                
        addBackgroundView()

        addCollectionView()
        
        addSpinnerView()
        
        showSpinner()
                
    }
        
    func setNavigationBarItems() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Add bar button items
        // Create custom UIBarButtonItem with system icons
        let profileButton = UIBarButtonItem(
            image: UIImage(systemName: "person.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapProfile)
        )
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 50
        
        let themeButton = UIBarButtonItem(
            image: UIImage(systemName: themeService.isDarkThemeActive ? "moon.fill" : "sun.max.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapTheme)
        )
        themeButton.width = 40
        
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName:  "gearshape.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapSettings)
        )
        
        navigationItem.leftBarButtonItems = [profileButton, fixedSpace]
        navigationItem.rightBarButtonItems = [settingsButton, themeButton]
        
        // Your existing logo setup
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.backgroundColor = .clear
        logoImageView.frame = CGRect.init(x: 0, y: 0,
                                          width: UIScreen.main.bounds.width * 0.8,
                                          height: 40)
        self.navigationItem.titleView = logoImageView
        
        
    }

    // This is needed to have consistent bg colour at the top safe area
    func addBackgroundView() {

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
      
        backgroundView.backgroundColor = UIColor(themeService.selectedTheme.mainBGColor) // Set the desired background color

        NSLayoutConstraint.activate([
            
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
        
    }
    
    func addCollectionView() {
        
        let paddingTop = ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).top
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: HorizontalCollectionViewCell.identifier)
        collectionView.register(CategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeader.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        view.addSubview(collectionView)
       
        NSLayoutConstraint.activate([
                        
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: paddingTop + 50),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Configure refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl // Add refresh control to collection view

    }
    
    func addSpinnerView() {
                
        let myProgressView = UIActivityIndicatorView(style: .large)
        myProgressView.translatesAutoresizingMaskIntoConstraints = false
        myProgressView.color = .white
        myProgressView.startAnimating()
        mySpinnerView.addSubview(myProgressView)
        
        NSLayoutConstraint.activate([
            myProgressView.centerXAnchor.constraint(equalTo: self.mySpinnerView.centerXAnchor),
            myProgressView.centerYAnchor.constraint(equalTo: self.mySpinnerView.centerYAnchor, constant: -50),
        ])
        
        mySpinnerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mySpinnerView)

        NSLayoutConstraint.activate([
            mySpinnerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mySpinnerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mySpinnerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mySpinnerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
    }
    
    func setUpData() {
        
        Publishers.CombineLatest(model.$allCategories.dropFirst(),
                                 themeService.$selectedTheme)
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: { [weak self] newCategoriesArrived, theme in
            self?.refreshAllView(theme: theme)
        })
        .store(in: &disposeBag)
        
        // Its always safer to call this function always AFTER the Reactive subscribes above !
        reloadData()

    }
    
    func refreshAllView(theme: Theme) {
        collectionView.reloadData()
        collectionView.backgroundColor = UIColor(theme.mainBGColor)
        backgroundView.backgroundColor = UIColor(theme.mainBGColor)
        mySpinnerView.backgroundColor = UIColor(theme.mainBGColor).withAlphaComponent(0.5)
        view.backgroundColor = UIColor(theme.navigationBarBackground)
        setNavigationBarItems()
    }
    
    func showSpinner() {
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.mySpinnerView.layer.opacity = 1.0
        }) { (succeed) -> Void in }
    }
    
    func hideSpinner() {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.mySpinnerView.layer.opacity = 0.0
        }) { (succeed) -> Void in }
    }
    
    
    func reloadData() {
        
        showSpinner()
        
        Task {
            await model.loadData()
            DispatchQueue.main.async { [weak self] in
                self?.setupCategoryVisibility()
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.hideSpinner()
            }
        }
    }
    
    // Selector methods for the custom UIBarButtonItems
    @objc private func didTapProfile() {
        print("didTapProfile button tapped")
    }
    
    @objc private func didTapTheme() {
        print("didTapTheme button tapped")
        themeService.selectedTheme = themeService.selectedTheme == .dark ? .light : .dark
    }
    
    @objc private func didTapSettings() {
        print("didTapSettings button tapped")
    }
    
    @objc private func refreshData() {
        reloadData()
    }
    
    private func setupCategoryVisibility() {
        categoryVisibility = Array(repeating: true, count: model.allCategories.count)
    }
    
}

// MARK: - DataSource and Delegate for EventsUIViewController
extension EventsUIViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard !categoryVisibility.isEmpty else { return 0 }
        return categoryVisibility[section] ? 1 : 0 // Only show if visible
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalCollectionViewCell.identifier, for: indexPath) as! HorizontalCollectionViewCell
        let category = model.allCategories[indexPath.section]
        
        cell.configure(with: category,
                       themeService: themeService,
                       dataManager: dataManager,
                       timerManager: timerManager,
                       itemSelected: { eventSelected in
            debugPrint("And here we could open another screen for shown event details !")
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryHeader.identifier, for: indexPath) as! CategoryHeader
            header.configure(with: model.allCategories[indexPath.section].categoryName,
                             isVisible: categoryVisibility.isEmpty ? true : categoryVisibility[indexPath.section],
                             sportId: model.allCategories[indexPath.section].sportId,
                             numberOfEvents: model.allCategories[indexPath.section].allEventsOfThisCategory.count,
                             themeService: themeService)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeader(_:)))
            header.addGestureRecognizer(tapGesture)
            header.tag = indexPath.section // Set tag to identify section
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 142) // Set the height of the section
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    @objc private func didTapHeader(_ sender: UITapGestureRecognizer) {
        guard let header = sender.view else { return }
        let section = header.tag
        
        categoryVisibility[section].toggle()
        
        self.collectionView.performBatchUpdates({
            collectionView.reloadSections(IndexSet(integer: section))
        }, completion: nil)
        
    }
}

