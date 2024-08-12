//
//  HomeVC.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit
import SnapKit
import Hero

class HomeVC: UIViewController, UITableViewDelegate , UISearchBarDelegate, QRCodeScannerDelegate{
  
    //MARK: Properties
    let searchBar = UISearchBar()
    let tableView = HomeTableView()
    var filteredTasks: [Task] = []
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Globals data: \(Globals.shared.tasks)")
        
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        setupTableView()
        setupSearchBar()
        filteredTasks = Globals.shared.tasks
        hideKeyboard()
    }
    //MARK: Helpers
    func setupUI(){
        view.backgroundColor = .systemBackground
        
        let topView = TopView(titleLabel: "Home")
        topView.settingsButton.addTarget(self, action: #selector(settingsButtonClicked), for: .touchUpInside)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.right.left.equalToSuperview()
            make.height.equalTo(67)
        }
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search in Tasks"
        navigationItem.titleView = searchBar
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.isEmpty {
               filteredTasks = Globals.shared.tasks
           } else {
               filteredTasks = Globals.shared.tasks.filter { task in
                   task.task.lowercased().contains(searchText.lowercased()) ||
                   task.title.lowercased().contains(searchText.lowercased()) ||
                   task.description.lowercased().contains(searchText.lowercased())
               }
           }
        tableView.reloadData()
    }
    
    // QRCodeScannerDelegate protokolünden gelen fonksiyon
    func didFindQRCode(code: String) {
        searchBar.text = code
        searchTasks(query: code) // Arama işlemini tetikleyin
    }

    // QR kod tarayıcısını başlatırken delegate'i ayarla
    func openQRCodeScanner() {
        let qrScannerVC = QRCodeScannerVC()
        qrScannerVC.delegate = self
        present(qrScannerVC, animated: true)
    }

    // Arama işlemini gerçekleştiren fonksiyon
    private func searchTasks(query: String) {
        filteredTasks = CoreDataHelper.shared.fetchTasks().filter { task in
            task.title?.lowercased().contains(query.lowercased()) ?? false ||
            task.descriptionTask?.lowercased().contains(query.lowercased()) ?? false
        }
        tableView.reloadData()
    }
    
    func hideKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    //MARK: Actions
    @objc func settingsButtonClicked(){
        let destinationVC = SettingsVC()
        destinationVC.hero.isEnabled = true
        destinationVC.hero.modalAnimationType = .slide(direction: .right)
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true)
    }
    @objc private func dismissKeyboard() {
          view.endEditing(true)
      }
}

//MARK: Extension + UITableViewDataSource
extension HomeVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        let task = filteredTasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//           let selectedTask = filteredTasks[indexPath.row]
//           print("selected task: \(selectedTask.title)")
//    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let selectedTask = filteredTasks[indexPath.row]
          
          let saveAction = UIContextualAction(style: .normal, title: "Save") { (action, view, completionHandler) in
              print("selected task: \(selectedTask.title)")
              CoreDataHelper.shared.saveTask(task: selectedTask.task,
                                             title: selectedTask.title,
                                             descriptionTask: selectedTask.description,
                                             colorCode: selectedTask.colorCode)
              completionHandler(true)
          }
          
        saveAction.backgroundColor = .systemGreen
          
          let configuration = UISwipeActionsConfiguration(actions: [saveAction])
          return configuration
      }
}
