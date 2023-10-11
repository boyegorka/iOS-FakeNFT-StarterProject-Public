//
//  NFTPreviewView.swift
//  FakeNFT
//
//  Created by Олег Аксененко on 11.10.2023.
//

import UIKit

protocol NFTPreviewViewDelegate: AnyObject {
    func didTapSubmitButton()
    func didTapCancelButton()
}

final class NFTPreviewView: UIView {
    private let blureContainerView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false

        return visualEffectView
    }()

    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true

        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.text = "Вы уверены, что хотите удалить объект из корзины?"
        label.textAlignment = .center
        label.font = .caption2

        return label
    }()

    private let submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.clipsToBounds = true

        let title = NSAttributedString(
            string: "Удалить",
            attributes: [
                .font: UIFont.bodyRegular
            ]
        )

        button.setAttributedTitle(title, for: .normal)

        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.textOnPrimary, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.clipsToBounds = true

        let title = NSAttributedString(
            string: "Вернуться",
            attributes: [
                .font: UIFont.bodyRegular
            ]
        )

        button.setAttributedTitle(title, for: .normal)

        return button
    }()

    weak var delegate: NFTPreviewViewDelegate?

    func setNFTImagePreview(_ preview: UIImage) {
        previewImageView.image = preview
    }

    init() {
        super.init(frame: .zero)

        submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)

        addSubview(blureContainerView)
        addSubview(previewImageView)
        addSubview(descriptionLabel)
        addSubview(submitButton)
        addSubview(cancelButton)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NFTPreviewView {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            blureContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blureContainerView.topAnchor.constraint(equalTo: topAnchor),
            blureContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blureContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            previewImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            previewImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            previewImageView.heightAnchor.constraint(equalToConstant: 108),
            previewImageView.widthAnchor.constraint(equalToConstant: 108),

            descriptionLabel.leadingAnchor.constraint(equalTo: previewImageView.leadingAnchor, constant: -36),
            descriptionLabel.trailingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: 36),
            descriptionLabel.topAnchor.constraint(equalTo: previewImageView.bottomAnchor, constant: 12),

            submitButton.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: -41),
            submitButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.widthAnchor.constraint(equalToConstant: 127),

            cancelButton.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 41),
            cancelButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 127)
        ])
    }

    @objc func didTapSubmitButton() {
        delegate?.didTapSubmitButton()
    }

    @objc func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }
}
