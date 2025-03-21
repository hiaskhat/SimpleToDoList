//
//  TaskCell.swift
//  SimpleToDoApp
//
//  Created by Асхат Баймуканов on 13.03.2025.
//

import UIKit

final class TaskCell: UITableViewCell {
    
    private let checkmarkButton = UIButton()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()

    var toggleCompletion: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        checkmarkButton.layer.cornerRadius = 12
        checkmarkButton.layer.borderWidth = 2
        checkmarkButton.layer.borderColor = UIColor.yellow.cgColor
        checkmarkButton.backgroundColor = .clear
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)

        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 2
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = UIColor.black.withAlphaComponent(0.5)

        contentView.addSubview(checkmarkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        
        setupConstraints()
    }

    private func setupConstraints() {
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkmarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 24),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    @objc private func checkmarkTapped() {
        toggleCompletion?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        titleLabel.textColor = .black
        descriptionLabel.textColor = .black

        checkmarkButton.setImage(UIImage(systemName: "circle")?.withTintColor(.yellow, renderingMode: .alwaysOriginal), for: .normal)
    }




    func configure(with task: Task) {
      
        backgroundColor = .systemBackground
        titleLabel.textColor = .label
        descriptionLabel.textColor = .secondaryLabel
        dateLabel.textColor = .tertiaryLabel
        
        // устанавливаем обычный текст
        titleLabel.text = task.title ?? "Без названия"
        descriptionLabel.text = task.taskDescription?.isEmpty == false ? task.taskDescription : ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateLabel.text = "\(dateFormatter.string(from: task.createdAt ?? Date()))"

        if task.isCompleted {
            let image = UIImage(systemName: "checkmark")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
            checkmarkButton.setImage(image, for: .normal)
            
//            titleLabel.textColor = UIColor.black.withAlphaComponent(0.5)
//            descriptionLabel.textColor = UIColor.darkGray.withAlphaComponent(0.5)
            titleLabel.alpha = 0.5
            descriptionLabel.alpha = 0.5
        } else {
            //let image = UIImage(systemName: "circle")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
            checkmarkButton.setImage(nil, for: .normal)
            
//            titleLabel.textColor = .black
//            descriptionLabel.textColor = .darkGray
            titleLabel.alpha = 1.0
            descriptionLabel.alpha = 1.0
        }
    }

}
