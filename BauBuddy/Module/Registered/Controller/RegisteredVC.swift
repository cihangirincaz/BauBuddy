//
//  RegisteredVC.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit
import SnapKit
import Hero

class RegisteredVC: UIViewController  {
    //MARK: Properties
    let tableView = RegisteredTableView()
    var registeredTask :[Task] = []
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registeredTask.removeAll()
        fetchCoreData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
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
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    func fetchCoreData() {
          CoreDataHelper.shared.fetchTasks { tasks, error in
              if let error = error {
                  print("Error occurred during fetch: \(error.localizedDescription)")
              } else if let tasks = tasks {
                  for coreDataTask in tasks {
                      let task = Task(coreDataTask: coreDataTask)
                      self.registeredTask.append(task)
                  }
              }
          }
        tableView.reloadData()
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
//MARK: Extension + UITableViewDataSource
extension RegisteredVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredTask.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RegisteredTableViewCell", for: indexPath) as? RegisteredTableViewCell else {
            return UITableViewCell()
        }
        let task = registeredTask[indexPath.row]
        cell.configure(with: task)
        return cell
    }
}
//MARK: Extension + UITableViewDelegate
extension RegisteredVC: UITableViewDelegate {
       func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           
           let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completionHandler) in
               guard let self = self else { return }
               let taskToDelete = self.registeredTask[indexPath.row]
               CoreDataHelper.shared.deleteTask(task: taskToDelete) { error in
                   if let error = error {
                       print("An error occurred while deleting: \(error.localizedDescription)")
                   } else {
                       self.registeredTask.remove(at: indexPath.row)
                       tableView.deleteRows(at: [indexPath], with: .automatic)
                       self.makeAlert(titleInput: "Successful!", messageInput: "Task deleted.")
                       print("")
                       tableView.reloadData()
                   }
               }
               completionHandler(true)
           }
           deleteAction.backgroundColor = .systemRed
           let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
           return configuration
       }
}
