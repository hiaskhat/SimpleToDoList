//
//  TodoViewController.swift
//  SimpleToDoApp
//
//  Created by Асхат Баймуканов on 13.03.2025.
//

import UIKit

final class TodoViewController: UIViewController {
    
    // ViewModel для работы с данными
    private var tasks: [Task] = []
    
    // UI Элементы
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let footerView = UIView()
    private let taskCountLabel = UILabel()
    private let addTaskButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTasks()
        setupNavigationBar()
        
        // чтобы обновить таблицу после загрузки API
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name("reloadData"), object: nil)

    }
    

    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
        title = "Задачи"
        
        // Настройка SearchBar
        searchBar.placeholder = "Поиск задач"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        // Настройка TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        view.addSubview(tableView)
        
        // Настройка Footer
        footerView.backgroundColor = .secondarySystemBackground
        view.addSubview(footerView)
        
        taskCountLabel.textColor = .label
        taskCountLabel.textAlignment = .center
        footerView.addSubview(taskCountLabel)
        
        addTaskButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addTaskButton.tintColor = .systemYellow
        addTaskButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        footerView.addSubview(addTaskButton)
        
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Задачи"
    }

    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 60),
            
            taskCountLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            taskCountLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            
            addTaskButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            addTaskButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            addTaskButton.widthAnchor.constraint(equalToConstant: 30),
            addTaskButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func loadTasks() {
        tasks = CoreDataManager.shared.fetchTasks()
        updateFooter()
        tableView.reloadData()
    }
    
    private func updateFooter() {
        taskCountLabel.text = "\(tasks.count) Задач"
    }
    
    @objc private func addTaskTapped() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    private func showEditAlert(for task: Task) {
        let alert = UIAlertController(title: "Редактировать задачу", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = task.title
        }

        alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { [weak self] _ in
            guard let newTitle = alert.textFields?.first?.text, !newTitle.isEmpty else { return }
            task.title = newTitle
            CoreDataManager.shared.saveContext()
            self?.tableView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        present(alert, animated: true)
    }

    private func deleteTask(_ task: Task, at indexPath: IndexPath) {
        CoreDataManager.shared.deleteTask(task: task)
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        updateFooter()
    }

    private func shareTask(_ task: Task) {
        let taskText = "Задача: \(task.title)\n Описание: \(task.taskDescription ?? "Нет описания")"
        let activityVC = UIActivityViewController(activityItems: [taskText], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    private func toggleTaskCompletion(_ task: Task) {
        CoreDataManager.shared.toggleTaskCompletion(task: task)
        tableView.reloadData()
    }

    // Метод для обновления таблицы
    @objc private func reloadTableView() {
        loadTasks()
        tableView.reloadData()
    }
}

extension TodoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]

        cell.configure(with: task)
        
        // обрабатываем нажатие на кружочек
        cell.toggleCompletion = { [weak self] in
            self?.toggleTaskCompletion(task)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let detailVC = TaskDetailViewController(task: task)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, completionHandler in
            let task = self.tasks[indexPath.row]
            CoreDataManager.shared.deleteTask(task: task)
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateFooter()
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let task = tasks[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.showEditAlert(for: task)
            }

            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.shareTask(task)
            }

            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteTask(task, at: indexPath)
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}

extension TodoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            loadTasks()
        } else {
            tasks = CoreDataManager.shared.fetchTasks().filter {
                ($0.title ?? "").lowercased().contains(searchText.lowercased())
            }
            tableView.reloadData()
        }
    }
}

extension TodoViewController: AddTaskDelegate {
    func didAddTask() {
        loadTasks() 
    }
}

