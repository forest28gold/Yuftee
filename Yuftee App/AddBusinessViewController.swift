//
//  AddBusinessViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 10/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

class AddBusinessViewController : NavPageViewController {
    
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var following: Bool = false
    var businessToAdd: BusinessToAdd?
    var tempLogo = UIImage(named: "tempLogo")
    
    override func viewDidLoad() {
        showBurger = false
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.logoView.image = tempLogo
        self.logoView.alpha = 0.12

        LogoDownloader.getImage(self.businessToAdd!.logo, handler: { logo in
            if logo != nil {
                self.logoView.image = logo
                self.logoView.alpha = 1.0
            }
        })

        self.name.text = businessToAdd?.name
        self.button.setTitle((self.following) ? "Unfollow" : "Follow", forState: .Normal)
        self.navigationItem.title = businessToAdd?.name
    }

    @IBAction func buttonClicked(sender: UIButton) {
        if following {
            User.sharedInstance.unFollowBusiness(self.businessToAdd!.id)
            self.button.setTitle("Follow", forState: .Normal)
        } else {
            User.sharedInstance.followBusiness(self.businessToAdd!.id)
            self.button.setTitle("Unfollow", forState: .Normal)
        }
        following = !following
    }
    
    func setBusiness(#business: BusinessToAdd, isFollowing following: Bool) {
        self.businessToAdd = business
        self.following = following
    }
    
    
  
}
