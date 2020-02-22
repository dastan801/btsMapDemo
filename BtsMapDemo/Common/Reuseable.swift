//
//  Reuseable.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/21/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import Foundation

public protocol Reuseable: class {
    static var reuseIdentifier: String { get }
}

extension Reuseable where Self: BaseTableViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
