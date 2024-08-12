//
//  RegisteredTableView.swift
//  BauBuddy
//
//  Created by cihangirincaz on 12.08.2024.
//

import UIKit

class RegisteredTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.register(RegisteredTableViewCell.self, forCellReuseIdentifier: "RegisteredTableViewCell")
    }
}
