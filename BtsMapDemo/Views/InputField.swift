//
//  InputField.swift
//  BtsMapDemo
//
//  Created by Дастан Сабет on 2/18/20.
//  Copyright © 2020 khangroup. All rights reserved.
//

import UIKit

enum SourceType: String {
    case source = "Точка А"
    case destination = "Точка Б"
}

protocol InputFieldTapable: class {
    func didTap(on inputField: InputField, with type: SourceType)
}

class InputField: BaseView {

    weak var delegate: InputFieldTapable?

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test"
        return label
    }()

    private var type: SourceType

    init(type: SourceType) {
        self.type = type
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupViews() {
        super.setupViews()
        setupGesture()
        setupAppearance()
        textLabel.text = type.rawValue
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        updateConstraints()
    }

    private func setupGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    private func setupAppearance() {
        backgroundColor = .black
        cornerRadius(8)
    }

    override func updateConstraints() {
        super.updateConstraints()
        let constraints = [
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc
    private func handleTap() {
        delegate?.didTap(on: self, with: type)
    }

    func setTitle(_ title: String?) {
        textLabel.text = title
    }

}
