//
//  HomeTableView.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit

class HomeTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
    }
}
