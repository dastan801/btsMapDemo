//
//  MapViewController.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/18/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit

class MapViewController: BaseViewController {

    private lazy var mapView: MapView = {
        let view = MapView()
        view.delegate = self
        return view
    }()

    override func loadView() {
        super.loadView()
        edgesForExtendedLayout = []
        view = mapView
    }

    private func setTitle() {
        navigationItem.title = "Я.Карта"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()


    }

}

extension MapViewController: InputFieldTapable {
    func didTap(on inputField: InputField, with type: SourceType) {
        let controller = SearchViewController(sourceType: type)
        navigationController?.pushViewController(controller, animated: true)
    }
}
