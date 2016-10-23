//
//  ProgressHUD.swift
//  Yelp
//
//  Created by Girge on 10/23/16.
//  Copyright © 2016 Girge. All rights reserved.
//

import Foundation
import SVProgressHUD

class ProgressHUD {
    class func setup() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setDefaultMaskType(.black)
    }
    class func show() {
        SVProgressHUD.show(withStatus: "Loading...")
    }
    class func dismiss() {
        SVProgressHUD.dismiss()
    }
}
