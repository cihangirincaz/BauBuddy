//
//  SavedTableView.swift
//  BauBuddy
//
//  Created by cihangirincaz on 12.08.2024.
//

import UIKit

class SavedTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.register(SavedTableViewCell.self, forCellReuseIdentifier: "SavedTableViewCell")
    }
}
