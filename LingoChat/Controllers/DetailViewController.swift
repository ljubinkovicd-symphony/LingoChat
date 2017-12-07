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

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var countryFlags = [
        (NSLocalizedString("English", comment: "English language selection for all incoming messages to be translated to it."), Languages.english, UIImage(named: "usa_icon")),
        (NSLocalizedString("Arabic", comment: "Arabic language selection for all incoming messages to be translated to it."), Languages.arabic, UIImage(named: "saudi_arabia_icon")),
        (NSLocalizedString("French", comment: "French language selection for all incoming messages to be translated to it."), Languages.french, UIImage(named: "france_icon")),
        (NSLocalizedString("Spanish", comment: "Spanish language selection for all incoming messages to be translated to it."), Languages.spanish, UIImage(named: "spain_icon")),
        (NSLocalizedString("Portuguese", comment: "Portuguese language selection for all incoming messages to be translated to it."), Languages.portuguese, UIImage(named: "portugal_icon"))
    ]

    let languagesTableView: UITableView = {
        
        let uiTableView = UITableView()
        uiTableView.translatesAutoresizingMaskIntoConstraints = false
        
        uiTableView.isScrollEnabled = false
        
        uiTableView.layer.cornerRadius = 16.0
        uiTableView.layer.masksToBounds = true
        
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
        dismiss(animated: true, completion: nil)
        
        // TODO: Communicate back to ChatLogController to set the language
        
    }
    
    // MARK: - Custom Methods
    fileprivate func setupScreenLayout() {
        
        view.backgroundColor = UIColor.clear
        
        view.addSubview(languagesTableView)
        
        languagesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        languagesTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        languagesTableView.widthAnchor.constraint(equalToConstant: 240.0).isActive = true
        languagesTableView.heightAnchor.constraint(equalToConstant: cellHeight * CGFloat(countryFlags.count)).isActive = true
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
        
        print(countryFlags[indexPath.row].1.rawValue)
        
//        close()
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
