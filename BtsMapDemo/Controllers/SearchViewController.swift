//
//  SearchViewController.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/18/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    private var sourceType: SourceType

    init(sourceType: SourceType) {
        self.sourceType = sourceType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }

    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = sourceType.rawValue
    }

}
