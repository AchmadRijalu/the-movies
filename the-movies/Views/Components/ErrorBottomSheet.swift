//
//  ErrorBottomSheet.swift
//  the-movies
//
//  Created by Achmad Rijalu on 17/06/25.
//

import UIKit

class ErrorBottomSheet: UIViewController {

    private let message: String

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "errorImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 140),
            imageView.widthAnchor.constraint(equalToConstant: 140)
        ])
        return imageView
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, messageLabel])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(message: String) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
        configureBottomSheet()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        messageLabel.text = message
    }
}

private extension ErrorBottomSheet {
    
    func configureBottomSheet() {
        modalPresentationStyle = .formSheet
        preferredContentSize = CGSize(width: 0, height: 220)

        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 24
        }
    }

    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}


