//
//  SettingsVC.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit
import SnapKit

class SettingsVC: UIViewController {
    //MARK: Properties
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    //MARK: Helpers
    func setupUI(){
        view.backgroundColor = .white
        let titleLabel = UILabel()
        titleLabel.text = "Settings"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(23)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
            make.width.equalTo(122)
        }
        let backButton = UIButton()
        backButton.setImage(.backButton, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(11)
            make.height.width.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    //MARK: Actions
    @objc func backButtonClicked(){
        self.hero.modalAnimationType = .slide(direction: .left)
        dismiss(animated: true, completion: nil)
    }
}
