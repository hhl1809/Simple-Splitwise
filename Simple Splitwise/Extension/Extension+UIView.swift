//
//  Extension+UIView.swift
//  Simple Splitwise
//
//  Created by HUYNH Hoc Luan on 3/14/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit

extension UIView {
    func setShadow(shadowRadius: CGFloat = 2.0, shadowColor: UIColor = UIColor.lightGray, shadowOffset: CGSize = CGSize(width: 2, height: 2), shadowOpacity: Float = 0.8, cornerRadius: CGFloat = 0) -> Void {
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.masksToBounds = false
    }
}
