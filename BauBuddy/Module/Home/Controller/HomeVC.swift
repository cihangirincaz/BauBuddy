//
//  HomeVC.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit
import SnapKit
import Hero

class HomeVC: UIViewController {
  
    //MARK: Properties
    var searchBar = UISearchBar()
    let tableView = HomeTableView()
    var filteredTasks: [Task] = []
    let emptyView = EmptyView(titleLabelText: "I am Sorry!\nYou are probably\n experiencing internet problems.", image: .emptyView)
    var refreshControl: UIRefreshControl!

    //MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSearchBar()
    }
    override func viewDidDisappear(_ animated: Bool) {
        Globals.shared.qrQuerry = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSearchBar()
        hideKeyboard()
        refreshController()
    }
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        adjustEmptyView()
    }
    //MARK: Helpers
    func setupUI(){
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
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
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    func setupTableView(){
        filteredTasks = Globals.shared.tasks
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    func hideKeyboard(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    func adjustEmptyView(){
        if Globals.shared.tasks.isEmpty {
            emptyView.isHidden = false
            tableView.isHidden = true
        } else {
            emptyView.isHidden = true
            tableView.isHidden = false
        }
    }
    func refreshController(){
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    func refreshData(completion: @escaping () -> Void) {
        APIManager.shared.initializeAppData { success in
            if success {
                self.makeAlert(titleInput: "Succesful!", messageInput: "Data was successfully extracted.")
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                self.makeAlert(titleInput: "Error!", messageInput: "Data retrieval failed.")
                DispatchQueue.main.async {
                    completion()
                }
            }
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
    @objc private func dismissKeyboard() {
          view.endEditing(true)
    }
    @objc func refreshTableView() {
          refreshData { [weak self] in
              self?.filteredTasks = Globals.shared.tasks
              self?.refreshControl.endRefreshing()
              self?.tableView.reloadData()
          }
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
}
//MARK: Extension + UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let selectedTask = filteredTasks[indexPath.row]
          
          let saveAction = UIContextualAction(style: .normal, title: "Save") { (action, view, completionHandler) in
              CoreDataHelper.shared.saveTask(task: selectedTask.task,
                                             title: selectedTask.title,
                                             descriptionTask: selectedTask.description,
                                             colorCode: selectedTask.colorCode)
              self.makeAlert(titleInput: "Successful!", messageInput: "Task saved.")
              completionHandler(true)
          }
          
        saveAction.backgroundColor = .systemGreen
          
          let configuration = UISwipeActionsConfiguration(actions: [saveAction])
          return configuration
      }
}
//MARK: Extension + UISearchBarDelegate
extension HomeVC: UISearchBarDelegate {
    func setupSearchBar() {
        searchBar.text = Globals.shared.qrQuerry
        searchBar.delegate = self
        searchBar.placeholder = "Search in Tasks"
        searchBar(searchBar, textDidChange: Globals.shared.qrQuerry)
        tableView.reloadData()
        navigationItem.titleView = searchBar
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.isEmpty {
               filteredTasks = Globals.shared.tasks
           } else {
               filteredTasks = Globals.shared.tasks.filter { task in
                   task.task.lowercased().contains(searchText.lowercased()) ||
                   task.title.lowercased().contains(searchText.lowercased()) ||
                   task.description.lowercased().contains(searchText.lowercased()) ||
                   task.colorCode.lowercased().contains(searchText.lowercased())
               }
           }
        tableView.reloadData()
    }
}


