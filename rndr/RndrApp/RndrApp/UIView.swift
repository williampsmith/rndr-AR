//
//  UIButton.swift
//  Used for implementing rounded edges and border colors for buttons in UI
//  Created by Robert Spark on 11/30/16.
//
//  Copyright © 2016 Robert Spark. All rights reserved.
//

import UIKit

//allows for attributes to be displayed in storyboard as UI attributes
@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor?
    {
        set
        {
            layer.borderColor = newValue!.cgColor
        }
        get
        {
            if let borderColor = layer.borderColor
            {
                return UIColor(cgColor:borderColor)
            }
            else
            {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat
    {
        set
        {
            layer.borderWidth = newValue
        }
        get
        {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat
    {
        set
        {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get
        {
            return layer.cornerRadius
        }
    }
}
