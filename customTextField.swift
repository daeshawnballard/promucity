//
//  customTextField.swift
//  Promucity
//
//  Created by Daeshawn Ballard on 3/21/17.
//  Copyright © 2017 imdaeshawn. All rights reserved.
//

import UIKit

class customTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.insetBy(dx: 10, dy: 5)
    }
    
    
}
