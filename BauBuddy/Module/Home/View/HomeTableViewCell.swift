//
//  HomeTableViewCell.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit
import SnapKit

class HomeTableViewCell: UITableViewCell {
    let taskLabel = UILabel()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let colorView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        contentView.addSubview(colorView)
        colorView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(10)
        }

        contentView.addSubview(taskLabel)
        taskLabel.snp.makeConstraints { make in
            make.left.equalTo(colorView.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(colorView.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
            make.top.equalTo(taskLabel.snp.bottom).offset(4)
        }

        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(8)
        }

        taskLabel.font = UIFont.systemFont(ofSize: 14)
        taskLabel.numberOfLines = 0

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0

        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .gray
    }

    func configure(with task: Task) {
        taskLabel.text = task.task
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        colorView.backgroundColor = UIColor(hex: task.colorCode)
    }
}
