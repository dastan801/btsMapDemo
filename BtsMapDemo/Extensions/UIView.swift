//
//  UIView.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/22/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit

extension UITableView {
    func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
}

extension UIView {
    func cornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
