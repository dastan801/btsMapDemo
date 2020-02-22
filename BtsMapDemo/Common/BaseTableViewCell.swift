//
//  BaseTableViewCell.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/21/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell, Reuseable {

    func setupViews() {}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
