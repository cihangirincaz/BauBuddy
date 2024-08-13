//
//  SplashVC.swift
//  BauBuddy
//
//  Created by cihangirincaz on 13.08.2024.
//

import UIKit
import SnapKit

class SplashVC: UIViewController {

    // MARK: - Properties
    private let logoImageView = UIImageView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        perform(#selector(navigateToHome), with: nil, afterDelay: 3.0) // 3 saniye sonra ana ekrana geçiş
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // logoImageView özelliklerini ayarlama
        logoImageView.image = UIImage(named: "your_logo_image") // Logonuzun ismini girin
        logoImageView.contentMode = .scaleAspectFit
        
        // logoImageView'i görünüme ekleme ve SnapKit ile konumlandırma
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
            make.height.equalTo(logoImageView.snp.width) // Kare bir görüntü
        }
    }

    // MARK: - Navigation
    @objc private func navigateToHome() {
        let homeVC = HomeVC() // Ana ekrana geçiş için HomeVC'yi başlatın
        let navigationController = UINavigationController(rootViewController: homeVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
