//
//  shadowView.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 3/21/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit

class shadowView: UIView {

    override func awakeFromNib() {
         super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }

}
