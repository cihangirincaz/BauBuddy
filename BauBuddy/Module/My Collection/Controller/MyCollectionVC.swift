//
//  MyCollectionVC.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit
import SnapKit
import Hero

class MyCollectionVC: UIViewController {
    //MARK: Properties
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchCoreData()
    }
    //MARK: Helpers
    func setupUI(){
        view.backgroundColor = .systemBackground

        let topView = TopView(titleLabel: "Registered")
        topView.settingsButton.addTarget(self, action: #selector(settingsButtonClicked), for: .touchUpInside)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.right.left.equalToSuperview()
            make.height.equalTo(67)
        }
    }
    func fetchCoreData(){
        let tasks = CoreDataHelper.shared.fetchTasks()
        for task in tasks {
            print("Görev Başlığı: \(task.title ?? "")")
            print("Görev Açıklaması: \(task.descriptionTask ?? "")")
        }

    }
    //MARK: Actions
    @objc func settingsButtonClicked(){
        let destinationVC = SettingsVC()
        destinationVC.hero.isEnabled = true
        destinationVC.hero.modalAnimationType = .slide(direction: .right)
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true)
    }
}
