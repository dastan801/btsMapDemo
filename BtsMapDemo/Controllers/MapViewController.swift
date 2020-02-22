//
//  MapViewController.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/18/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit
import YandexMapKitDirections

class MapViewController: BaseViewController {

    private var drivingSession: YMKDrivingSession?
    private var sourcePoint: YMKPoint?
    private var destinationPoint: YMKPoint?
    private lazy var drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        navigationItem.title = "Я.Карта"
    }

}

// MARK: Selected Source Type
extension MapViewController: MapViewDelegate {

    func didTap(on inputField: InputField, with sourceType: SourceType, map: YMKMap) {
        let controller = SearchViewController(sourceType: sourceType, map: map, delegate: self)
        navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: Selected point handler
extension MapViewController: PointSelectable {

    func didSelect(geoObject: YMKGeoObjectCollectionItem, sourceType: SourceType) {
        mapView.setText(geoObject.obj?.name, with: sourceType)
        configurePoint(with: geoObject, sourceType: sourceType)
    }

}

// MARK: Set selected Point
extension MapViewController {

    private func configurePoint(with geoObject: YMKGeoObjectCollectionItem, sourceType: SourceType) {
        switch sourceType {
        case .source:
            sourcePoint = geoObject.obj?.geometry.first?.point
        case .destination:
            destinationPoint = geoObject.obj?.geometry.first?.point
        }
        checkForPoints()
    }

    private func checkForPoints() {
        guard let point1 = sourcePoint, let point2 = destinationPoint else { return }
        drawRoute(with: point1, and: point2)
    }

}

// MARK: Request to Draw Route
extension MapViewController {

    private func drawRoute(with point1: YMKPoint, and point2: YMKPoint) {
        let requestPoints = [
            YMKRequestPoint(point: point1, type: .waypoint, pointContext: nil),
            YMKRequestPoint(point: point2, type: .waypoint, pointContext: nil)
        ]

        let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                self.onRoutesReceived(routes, point1, point2)
            } else {
                self.onRoutesError(error!)
            }
        }

        drivingSession?.cancel()
        drivingSession = drivingRouter.requestRoutes(
            with: requestPoints,
            drivingOptions: YMKDrivingDrivingOptions(),
            routeHandler: responseHandler)
    }

    private func onRoutesReceived(_ routes: [YMKDrivingRoute], _ point1: YMKPoint, _ point2: YMKPoint) {
        guard !routes.isEmpty else {
            mapView.clear()
            return
        }
        mapView.drawRoute(routes[0], point1: point1, point2: point2)
    }

    private func onRoutesError(_ error: Error) {
        let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }

        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }

}
