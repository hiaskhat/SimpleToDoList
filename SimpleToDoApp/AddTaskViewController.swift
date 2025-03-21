//
//  AddTaskViewController.swift
//  SimpleToDoApp
//
//  Created by Асхат Баймуканов on 13.03.2025.
//

import UIKit

protocol AddTaskDelegate: AnyObject {
    func didAddTask()
}

final class AddTaskViewController: UIViewController {
    
    weak var delegate: AddTaskDelegate?

    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Новая задача"
        
        // Настройка titleTextField
        titleTextField.placeholder = "Введите название"
        titleTextField.borderStyle = .roundedRect
        view.addSubview(titleTextField)
        
        // Настройка descriptionTextView
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 8
        view.addSubview(descriptionTextView)
        
        // Настройка saveButton
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        view.addSubview(saveButton)
        
        setupConstraints()
    }

    private func setupConstraints() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func saveTask() {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let description = descriptionTextView.text ?? ""
        
        CoreDataManager.shared.createTask(title: title, description: description)
        
        delegate?.didAddTask() 
        navigationController?.popViewController(animated: true)
    }
}
