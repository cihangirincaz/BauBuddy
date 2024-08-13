//
//  SavedVC.swift
//  BauBuddy
//
//  Created by cihangirincaz on 10.08.2024.
//

import UIKit
import SnapKit
import Hero

class SavedVC: UIViewController  {
    //MARK: Properties
    let tableView = SavedTableView()
    var savedTask :[Task] = []
    let emptyView = EmptyView(titleLabelText: "Saved field is empty.\nGo to Home\nand start saving", image: UIImage(resource: .folder).withRenderingMode(.alwaysTemplate) )
    
    //MARK: Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        adjustEmptyView()
    }
    //MARK: Helpers
    func setupUI(){
        view.backgroundColor = .systemBackground

        let topView = TopView(titleLabel: "Saved")
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
        emptyView.imageView.tintColor = .mainColor
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(32)
            make.width.height.equalTo(view.frame.width*(0.6))
            make.centerX.equalToSuperview()
        }
    }
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    func fetchCoreData() {
        savedTask.removeAll()
          CoreDataHelper.shared.fetchTasks { tasks, error in
              if let error = error {
                  print("Error occurred during fetch: \(error.localizedDescription)")
              } else if let tasks = tasks {
                  for coreDataTask in tasks {
                      let task = Task(coreDataTask: coreDataTask)
                      self.savedTask.append(task)
                  }
              }
          }
        tableView.reloadData()
    }
    func adjustEmptyView(){
        if savedTask.isEmpty {
            emptyView.isHidden = false
            tableView.isHidden = true
        } else {
            emptyView.isHidden = true
            tableView.isHidden = false
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
//MARK: Extension + UITableViewDataSource
extension SavedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTask.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedTableViewCell", for: indexPath) as? SavedTableViewCell else {
            return UITableViewCell()
        }
        let task = savedTask[indexPath.row]
        cell.configure(with: task)
        return cell
    }
}
//MARK: Extension + UITableViewDelegate
extension SavedVC: UITableViewDelegate {
       func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           
           let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
               guard let self = self else { return }
               let taskToDelete = self.savedTask[indexPath.row]
               CoreDataHelper.shared.deleteTask(task: taskToDelete) { error in
                   if let error = error {
                       print("An error occurred while deleting: \(error.localizedDescription)")
                   } else {
                       self.savedTask.remove(at: indexPath.row)
                       tableView.deleteRows(at: [indexPath], with: .automatic)
                       self.makeAlert(titleInput: "Successful!", messageInput: "Task deleted.")
                       print("")
                       tableView.reloadData()
                       self.adjustEmptyView()
                   }
               }
               completionHandler(true)
           }
           deleteAction.backgroundColor = .systemRed
           let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
           return configuration
       }
}
