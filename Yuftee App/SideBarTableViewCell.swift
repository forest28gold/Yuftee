//
//  TableViewCell.swift
//  Yuftee
//
//  Created by AppsCreationTech on 29/12/2014.
//  Copyright (c) 2014 Yuftee. All rights reserved.
//

import UIKit

class SideBarTableViewCell: UITableViewCell {

    var leftImage = UIImageView()
    
    var hideLine = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(leftImage)
        leftImage.contentMode = .ScaleAspectFill
        leftImage.frame = CGRectMake(8, 8, 27, 27)
        textLabel?.frame = CGRectMake(42, 7, self.bounds.width - 54, 30)
        if !hideLine {
            let space: CGFloat = 8
            let lineView = UIView(frame: CGRectMake(space, self.bounds.height - 1, self.bounds.width - space, 1))
            lineView.backgroundColor = "b19d89".UIColor
            self.addSubview(lineView)
        }
    }

}
