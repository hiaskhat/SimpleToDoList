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
        let isDataLoaded = !UserDefaults.standard.bool(forKey: userDefaultsKey)
        return isDataLoaded
    }

    // Загружаем задачи из API
    func fetchTodosFromAPI(completion: @escaping () -> Void) {
        guard let url = URL(string: apiURL) else { return }

        if UserDefaults.standard.bool(forKey: userDefaultsKey) {
            return
        }

        //ставим тру и теперь больше с апи не загружаем
        UserDefaults.standard.setValue(true, forKey: userDefaultsKey)


        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                let todos = decodedResponse.todos

                DispatchQueue.main.async {
                    
                    // удаляем старые задачи перед загрузкой новых
                    CoreDataManager.shared.deleteAllTasks()

                    self.saveTodosToCoreData(todos: todos)
                    completion()

                    // обновляем таблицу
                    NotificationCenter.default.post(name: NSNotification.Name("reloadData"), object: nil)
                }
            } catch {
                print("Ошибка декодирования JSON: \(error)")
            }
        }.resume()
    }


    private func saveTodosToCoreData(todos: [TodoItem]) {
        //сохраняем по каждой задаче
        for todo in todos {
            let newTask = Task(context: CoreDataManager.shared.context)
            newTask.id = UUID()
            newTask.title = todo.todo
            newTask.taskDescription = ""
            newTask.createdAt = Date()
            newTask.isCompleted = todo.completed
        }
        CoreDataManager.shared.saveContext()
    }


}
