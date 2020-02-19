//
//  MapView.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/18/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit
import YandexMapKit

class MapView: BaseView {

    weak var delegate: InputFieldTapable?

    private lazy var mapView: YMKMapView = {
        let view = YMKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var mapWindow: YMKMapWindow = {
        return mapView.mapWindow
    }()

    private lazy var sourceInputField: InputField = {
        let view = InputField(type: .source)
        view.delegate = self
        return view
    }()

    private lazy var destinationInputField: InputField = {
        let view = InputField(type: .destination)
        view.delegate = self
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sourceInputField, destinationInputField])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func setupViews() {
        super.setupViews()
        [mapView, stackView].forEach(addSubview)
        updateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()
        let constraints = [
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ]
        NSLayoutConstraint.activate(constraints)
    }

}

extension MapView: InputFieldTapable {
    func didTap(on inputField: InputField, with type: SourceType) {
        delegate?.didTap(on: inputField, with: type)
    }
}
