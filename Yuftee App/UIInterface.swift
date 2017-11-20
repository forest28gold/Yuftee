//
//  UIInterface.swift
//  Yuftee
//
//  Created by AppsCreationTech on 25/06/15.
//  Copyright (c) 2015 Yuftee. All rights reserved.
//

import UIKit

class UIInterface
{
    class func circleImage (image:UIImageView) -> UIImageView
    {
        image.layer.cornerRadius = image.frame.size.width / 2;
        image.layer.borderColor = UIColor.blackColor().CGColor
        image.layer.borderWidth = 1.0
        image.clipsToBounds = true
        return image
    }
}
