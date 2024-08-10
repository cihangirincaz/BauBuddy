//
//  TopView.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit
import SnapKit

class TopView: UIView {
    // MARK: Properties
    let appNameLabel = UILabel()
    let titleLabel = UILabel()
    let settingsButton = UIButton()
    
    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    init(titleLabel: String) {
        super.init(frame: .zero)
        setupViews()
        self.titleLabel.text = titleLabel
    }

    // MARK: Helpers

    private func setupViews() {
        appNameLabel.text = "Bau Buddy"
        appNameLabel.textColor = .placeholder
        appNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        appNameLabel.textAlignment = .left
        addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { make in
            make.width.equalTo(138)
            make.height.equalTo(24)
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(39)
            make.top.equalTo(appNameLabel.snp.bottom)
            make.left.equalTo(appNameLabel)
        }
        settingsButton.setImage(.settingsButton, for: .normal)
        settingsButton.backgroundColor = .systemBackground
        addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.width.height.equalTo(28)
            make.top.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(24)
        }
    }
}

