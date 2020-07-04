//
//  Extensions.swift
//  OBSCam
//
//  Created by Davide Toldo on 01.10.20.
//  Copyright © 2020 Davide Toldo. All rights reserved.
//

import UIKit

extension UITabBar {
    private static var storedHeight: CGFloat?
    @objc static var height: CGFloat {
        get {
            if let height = storedHeight { return height }
            storedHeight = UITabBarController().tabBar.frame.size.height
            return storedHeight ?? 0
        }
    }
}
