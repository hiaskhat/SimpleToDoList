//
//  TaskService.swift
//  SimpleToDoApp
//
//  Created by Асхат Баймуканов on 13.03.2025.
//

import Foundation

struct TodoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
}

struct TodoResponse: Codable {
    let todos: [TodoItem]
}


final class TaskService {
    static let shared = TaskService() // Singleton

    private let apiURL = "https://dummyjson.com/todos"
    private let userDefaultsKey = "isDataLoaded"

    // Проверяем, загружались ли данные раньше
    func shouldLoadData() -> Bool {
        return !UserDefaults.standard.bool(forKey: userDefaultsKey)
    }

    // Загружаем задачи из API
    func fetchTodosFromAPI(completion: @escaping () -> Void) {
        guard let url = URL(string: apiURL) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Ошибка загрузки: \(error?.localizedDescription)" )
                return
            }

            do {
//                let decodedData = try JSONDecoder().decode([String: [TodoItem]].self, from: data)
//                let todos = decodedData["todos"] ?? []
                let decodedResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                    let todos = decodedResponse.todos

                DispatchQueue.main.async {
                    self.saveTodosToCoreData(todos: todos)
                    UserDefaults.standard.setValue(true, forKey: self.userDefaultsKey) // Помечаем, что данные загружены
                    completion()
                }
            } catch {
                print("Ошибка декодирования JSON: \(error)")
            }
        }.resume()
    }

    // Сохранение задач в Core Data
    private func saveTodosToCoreData(todos: [TodoItem]) {
        for todo in todos {
            CoreDataManager.shared.createTask(title: todo.todo, description: "")
        }
    }
}
