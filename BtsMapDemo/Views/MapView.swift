//
//  MapView.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/18/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit
import YandexMapKit
import YandexMapKitDirections

protocol MapViewDelegate: class {
    func didTap(on inputField: InputField, with sourceType: SourceType, map: YMKMap)
}

class MapView: BaseView {

    weak var delegate: MapViewDelegate?

    private lazy var mapView: YMKMapView = {
        let view = YMKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var mapWindow: YMKMapWindow = {
        return mapView.mapWindow
    }()

    private lazy var map: YMKMap = {
        return mapWindow.map
    }()

    private lazy var mapObjects: YMKMapObjectCollection = {
        return map.mapObjects
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
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setText(_ text: String?, with sourceType: SourceType) {
        switch sourceType {
        case .source:
            sourceInputField.setTitle(text)
        case .destination:
            destinationInputField.setTitle(text)
        }
    }

    func drawRoute(_ route: YMKDrivingRoute, point1: YMKPoint, point2: YMKPoint) {
        clear()
        mapObjects.addPolyline(with: route.geometry)
        let position = YMKCameraPosition(target: point1, zoom: 14, azimuth: 0, tilt: 0)
        map.move(with: position, animationType: .init(type: .linear, duration: 0.5), cameraCallback: nil)
    }

    func clear() {
        mapObjects.clear()
    }

}

extension MapView: InputFieldTapable {
    func didTap(on inputField: InputField, with type: SourceType) {
        delegate?.didTap(on: inputField, with: type, map: map)
    }
}

//extension YMKPoint {
//    static func - (lhs: YMKPoint, rhs: YMKPoint) -> YMKPoint {
//        let diffLat = abs(lhs.latitude - rhs.latitude)
//        let diffLon = abs(lhs.longitude - rhs.longitude)
//        let lat = min(lhs.latitude, rhs.latitude) + diffLat/2
//        let lon = min(lhs.longitude, rhs.longitude) + diffLon/2
//        let point = YMKPoint(latitude: lat, longitude: lon)
//        return point
//    }
//}
