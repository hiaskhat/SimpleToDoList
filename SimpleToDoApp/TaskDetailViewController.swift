//
//  TaskDetailViewController.swift
//  SimpleToDoApp
//
//  Created by Асхат Баймуканов on 13.03.2025.
//

import UIKit

final class TaskDetailViewController: UIViewController {
    
    private let task: Task
    
    // UI элементы
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    
    init(task: Task) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Детали задачи"
        
        // Настройка titleLabel
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        
        // Настройка descriptionLabel
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        
        // Настройка dateLabel
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        
        // Добавление элементов на экран
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(dateLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureUI() {
        titleLabel.text = task.title
        descriptionLabel.text = task.taskDescription?.isEmpty == false ? task.taskDescription : "Нет описания"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = "Создано: \(dateFormatter.string(from: task.createdAt ?? Date()))"
    }
}
