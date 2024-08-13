//
//  EmptyView.swift
//  BauBuddy
//
//  Created by cihangirincaz on 13.08.2024.
//

import UIKit
import SnapKit

class EmptyView: UIView {

    // MARK: Properties
    let titleLabel = UILabel()
    let imageView = UIImageView()

    // MARK: Initializers
    init(titleLabelText: String, image: UIImage?) {
        super.init(frame: .zero)
        setupUI(titleLabelText: titleLabelText, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup UI
    private func setupUI(titleLabelText: String, image: UIImage?) {
        titleLabel.text = titleLabelText
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .mainColor
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(32)
        }

        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.width.height.equalToSuperview().multipliedBy(0.8)
        }
    }
}
