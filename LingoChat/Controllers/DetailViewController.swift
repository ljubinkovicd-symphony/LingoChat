//
//  DetailViewController.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 12/7/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

// There is NEED to create a delegate protocol because there’s nothing to communicate back to the SearchViewController.
import UIKit

private let cellId = "cellId"
private let cellHeight: CGFloat = 60.0
private let headerHeight: CGFloat = 44.0

// Think of the delegate protocol as a contract between screen B, in this case the Add Item View Controller, and any screens that wish to use it.
protocol DetailViewControllerDelegate: class {
    func detailViewControllerDidCancel(_ controller: DetailViewController)
    func detailViewController(_ controller: DetailViewController, didFinishSelecting language: Languages)
}

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    weak var delegate: DetailViewControllerDelegate?
    
    var countryFlags = [
        (NSLocalizedString("English", comment: "English language selection for all incoming messages to be translated to it."), Languages.english, UIImage(named: "usa_icon")),
        (NSLocalizedString("Arabic", comment: "Arabic language selection for all incoming messages to be translated to it."), Languages.arabic, UIImage(named: "saudi_arabia_icon")),
        (NSLocalizedString("French", comment: "French language selection for all incoming messages to be translated to it."), Languages.french, UIImage(named: "france_icon")),
        (NSLocalizedString("Spanish", comment: "Spanish language selection for all incoming messages to be translated to it."), Languages.spanish, UIImage(named: "spain_icon")),
        (NSLocalizedString("Portuguese", comment: "Portuguese language selection for all incoming messages to be translated to it."), Languages.portuguese, UIImage(named: "portugal_icon"))
    ]

    let containerView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.backgroundColor = UIColor(rgb: 0x0077BE) // Ocean Blue Color
        
        uiView.layer.cornerRadius = 16.0
        uiView.layer.masksToBounds = true
        
        return uiView
    }()
    
    /*
     Style    Font    Size
     .largeTitle    SFUIDisplay    34.0
     .title1    SFUIDisplay (-Light on iOS <=10)    28.0
     .title2    SFUIDisplay    22.0
     .title3    SFUIDisplay    20.0
     .headline    SFUIText-Semibold    17.0
     .callout    SFUIText    16.0
     .subheadline    SFUIText    15.0
     .body    SFUIText    17.0
     .footnote    SFUIText    13.0
     .caption1    SFUIText    12.0
     .caption2    SFUIText    11.0
     */
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Translate all messages to:"
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    let languagesTableView: UITableView = {
        
        let uiTableView = UITableView()
        uiTableView.translatesAutoresizingMaskIntoConstraints = false
        
        uiTableView.isScrollEnabled = false
        
        return uiTableView
    }()
    
    // MARK: - Initialization Methods
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreenLayout()
        
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
        
        languagesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func close() {
        delegate?.detailViewControllerDidCancel(self)
    }
    
    // MARK: - Custom Methods
    fileprivate func setupScreenLayout() {
        
        view.backgroundColor = UIColor.clear
        
        view.addSubview(containerView)
        containerView.addSubview(headerLabel)
        containerView.addSubview(languagesTableView)
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 280.0).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: cellHeight * CGFloat(countryFlags.count) + headerHeight).isActive = true
        
        headerLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        headerLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true
        
        languagesTableView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        languagesTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
        languagesTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        languagesTableView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryFlags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = countryFlags[indexPath.row].0
        cell.imageView?.image = countryFlags[indexPath.row].2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let countryFlagInfo = self.countryFlags[(indexPath as NSIndexPath).row]
        
        print(countryFlagInfo.1)
        
        // Communicate back to ChatLogController to set the language
        chooseLanguage(language: countryFlagInfo.1)
    }
    
    func chooseLanguage(language: Languages) {
        delegate?.detailViewController(self, didFinishSelecting: language)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return BounceAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideOutAnimationController()
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
