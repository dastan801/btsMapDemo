//
//  BaseView.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/18/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit

class BaseView: UIView {

    func setupViews() {}

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
