//
//  textFieldShadow.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 5/2/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit

class textFieldShadow: UITextField {
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
}
