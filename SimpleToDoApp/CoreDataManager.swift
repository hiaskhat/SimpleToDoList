//
//  CoreDataManager.swift
//  SimpleToDoApp
//
//  Created by Асхат Баймуканов on 11.03.2025.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager() // Singleton

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "SimpleToDoApp") 
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Ошибка загрузки кор дата: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Сохранение контекста
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Ошибка сохранения кордата: \(error)")
            }
        }
    }
    
    func deleteAllTasks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Ошибка при удалении всех задач: \(error)")
        }
    }
    
    

    
    // MARK: - CRUD Методы

      // 1. Создание задачи
      func createTask(title: String, description: String) {
          let newTask = Task(context: context)
          newTask.id = UUID()
          newTask.title = title
          newTask.taskDescription = description
          newTask.createdAt = Date()
          newTask.isCompleted = false

          saveContext()
      }

      // 2. Получение всех задач
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            let tasks = try context.fetch(request)
            //print("кордата загружено задач: \(tasks.count)")
            return tasks
        } catch {
            return []
        }
    }


      // 3. Обновление статуса задачи (выполнена/не выполнена)
      func toggleTaskCompletion(task: Task) {
          task.isCompleted.toggle()
          saveContext()
          
          // После изменения статуса, отправляем обновление таблицы
        NotificationCenter.default.post(name: NSNotification.Name("reloadData"), object: nil)

      }

      // 4. Удаление задачи
      func deleteTask(task: Task) {
          context.delete(task)
          saveContext()
      }
}

