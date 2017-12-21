//
//  CircleView.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 5/28/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIImageView {

    // Take the height and cut it in half to make a circle
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    
    
}
