//
//  NavPageViewController.swift
//  Yuftee App
//
//  Created by AppsCreationTech on 02/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

protocol BurgerButtonDelegate {
    func toggleSidebar()
}

class NavPageViewController: UIViewController {
    
    var burgerButton: UIBarButtonItem?
    var delegate: BurgerButtonDelegate?
    var navDelegate: NavDelegate?
    var showBurger = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = "E7E5E3".UIColor

        if showBurger {
            let img = UIImage(named: "menu")
            burgerButton = UIBarButtonItem(image: img, style: .Plain, target: self, action: "burgerClicked")
            self.navigationItem.leftBarButtonItem = burgerButton
            burgerButton?.tintColor = "E7E5E3".UIColor
        } else {
            self.navigationItem.backBarButtonItem?.enabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func burgerClicked () {
        delegate?.toggleSidebar()
    }
    
}
