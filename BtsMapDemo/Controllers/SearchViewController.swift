//
//  SearchViewController.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/18/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit
import YandexMapKit
import YandexMapKitSearch

protocol PointSelectable: class {
    func didSelect(geoObject: YMKGeoObjectCollectionItem, sourceType: SourceType)
}

class SearchViewController: UITableViewController {

    private weak var delegate: PointSelectable?

    private var searchSession: YMKSearchSession?
    private lazy var searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)

    private var collectionItems: [YMKGeoObjectCollectionItem] = [] {
        didSet { tableView.reload() }
    }

    private let BOUNDING_BOX = YMKBoundingBox()
    private let SEARCH_OPTIONS = YMKSearchOptions()

    private var sourceType: SourceType
    private unowned var map: YMKMap

    init(sourceType: SourceType, map: YMKMap, delegate: PointSelectable?) {
        self.sourceType = sourceType
        self.map = map
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Поиск"
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        setupTableView()
        setupNavigationItem()
        definesPresentationContext = true
    }

    private func setupTableView() {
        tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: BaseTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
    }

    private func setupNavigationItem() {
        navigationItem.title = sourceType.rawValue
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func object(for path: IndexPath) -> YMKGeoObjectCollectionItem? {
        guard path.row < collectionItems.count else { return nil }
        return collectionItems[path.row]
    }

}
// MARK: DataSource
extension SearchViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt path: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: BaseTableViewCell.reuseIdentifier, for: path)
    }

}
// MARK: Delegate
extension SearchViewController {

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt path: IndexPath) {
        let item = object(for: path)
        cell.textLabel?.text = item?.obj?.name
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt path: IndexPath) {
        guard let selectedObject = object(for: path) else { return }
        delegate?.didSelect(geoObject: selectedObject, sourceType: sourceType)
        navigationController?.popViewController(animated: true)
    }

}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text!
        search(text: query)
//        queryChanged(to: query)
    }
}

// MARK: Search for suggestions with query
extension SearchViewController {

//    func queryChanged(to text: String) {
//        let responseHandler = { [weak self] (items: [YMKSuggestItem]?, error: Error?) -> Void in
//            guard let items = items else {
//                self?.suggestItems = []
//                return
//            }
//            self?.suggestItems = items
//        }
//
//        searchManager.suggest(
//            withText: text,
//            window: BOUNDING_BOX,
//            searchOptions: SEARCH_OPTIONS,
//            responseHandler: responseHandler)
//    }
}

// MARK: Search exact place with text
extension SearchViewController {

    private func search(text: String) {
        let responseHandler = {(searchResponse: YMKSearchResponse?, error: Error?) -> Void in
            if let response = searchResponse {
                self.onSearchResponse(response)
            } else {
                self.onSearchError(error!)
            }
        }
        searchSession?.cancel()
        searchSession = searchManager.submit(
            withText: text,
            geometry: YMKVisibleRegionUtils.toPolygon(with: map.visibleRegion),
            searchOptions: YMKSearchOptions(),
            responseHandler: responseHandler)
    }

    private func onSearchResponse(_ response: YMKSearchResponse) {
        self.collectionItems = response.collection.children
    }

    private func onSearchError(_ error: Error) {
        let searchError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if searchError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if searchError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }

        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }

}
