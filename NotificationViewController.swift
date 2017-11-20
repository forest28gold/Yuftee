//
//  NotificationViewController.swift
//  Yuftee
//
//  Created by AppsCreationTech on 26/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//   


import UIKit

protocol NotificationDelegate {
    func notificationTapped ()
    func notificationTapped (update: Update)
}

class NotificationViewController: UIViewController {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var tap = UITapGestureRecognizer()
    var update: Update? {
        didSet {
            topLabel.text = "Update from \(update!.getBusiness().name)"
            bottomLabel.text = update!.title
            logoView.image = update!.getBusiness().logoImage
        }
    }
    
    var delegate: NotificationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: "tapped")
        self.view.addGestureRecognizer(tap)
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tapped () {
        delegate?.notificationTapped(update!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
