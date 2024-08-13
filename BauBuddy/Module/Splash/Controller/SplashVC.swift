//
//  SplashVC.swift
//  BauBuddy
//
//  Created by cihangirincaz on 13.08.2024.
//

import UIKit
import SnapKit
import Hero

class SplashVC: UIViewController {

    // MARK: Properties
    private let logoImageView = UIImageView()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startProgressBarAnimation()
        perform(#selector(navigateToHome), with: nil, afterDelay: 3.0)
    }

    // MARK: Helpers
    private func setupUI() {
        view.backgroundColor = .mainColor
        logoImageView.image = .appIcon
        logoImageView.layer.cornerRadius = 24
        logoImageView.layer.masksToBounds = true
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
            make.height.equalTo(logoImageView.snp.width)
        }
        
        progressBar.trackTintColor = .clear
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        view.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(32)
            make.width.equalTo(logoImageView.snp.width)
            make.height.equalTo(10)
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = progressBar.bounds
        gradientLayer.cornerRadius = 5
        
        if let progressImage = getImageFrom(gradientLayer: gradientLayer) {
            progressBar.progressImage = progressImage
        }
    }
    
    private func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, gradientLayer.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    private func startProgressBarAnimation() {
        progressBar.setProgress(0.0, animated: false)
        
        UIView.animate(withDuration: 3.0) {
            self.progressBar.setProgress(1.0, animated: true)
        }
    }

    // MARK: Actions
    @objc private func navigateToHome() {
        let destinationVC = TabbarController()
        destinationVC.hero.isEnabled = true
        destinationVC.hero.modalAnimationType = .slide(direction: .right)
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true)
    }
}
