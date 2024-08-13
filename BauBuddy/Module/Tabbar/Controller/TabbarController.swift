//
//  TabbarController.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit
import SnapKit

class TabbarController: UITabBarController {
    //MARK: Properties
    var tabbarImageView = UIImageView()
    let QRButton = UIButton()
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureViewControllers()
    }
    //MARK: - Helpers
    func configureViewControllers(){
        let homeVC = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: "", image: nil, tag: 0)
        let savedVC = SavedVC()
        savedVC.tabBarItem = UITabBarItem(title: "", image: nil, tag: 1)
        viewControllers = [homeVC, savedVC]
    }
    func setupUI(){
        tabbarImageView.image = .firstTabbar
        tabbarImageView.contentMode = .scaleAspectFit
        view.addSubview(tabbarImageView)
        tabbarImageView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(163)
        }
        QRButton.setImage(.qrButton, for: .normal)
        QRButton.addTarget(self, action: #selector(QRButtonClicked), for: .touchUpInside)
        view.addSubview(QRButton)
        QRButton.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.bottom.equalTo(tabbarImageView.snp.bottom).inset(60)
            make.centerX.equalToSuperview()
        }
    }
    //MARK: Actions
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            tabbarImageView.image = .firstTabbar
        } else if item.tag == 1{
            tabbarImageView.image = .secondTabbar
        }
    }
    @objc func QRButtonClicked(){
        let destinationVC = QRCodeScannerVC()
        destinationVC.hero.isEnabled = true
        destinationVC.hero.modalAnimationType = .slide(direction: .up)
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true)
    }
}
