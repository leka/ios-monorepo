// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

@MainActor
class Navigation: ObservableObject {

    static let shared = Navigation()

    enum Category: String, CaseIterable, Identifiable {
        case fruits = "Fruits"
        case animals = "Animals"
        case actions = "Actions"

        var id: String { self.rawValue }
    }

    struct Coordinator {
        var category: Category?
        var path: NavigationPath

        init(category: Category, path: NavigationPath = NavigationPath()) {
            self.category = category
            self.path = path
        }

        init(category: Category, path: [AnyHashable]) {
            self.init(category: category)

            path.forEach { self.path.append($0) }
        }

        mutating func reset() {
            path.removeLast(path.count)
        }

        mutating func setPath(_ path: [AnyHashable]) {
            reset()
            path.forEach { self.path.append($0) }
        }

        mutating func set(category newCategory: Category) {
            guard category != newCategory else { return }
            category = newCategory
        }

        mutating func set(path newPath: AnyHashable..., for category: Category) {
            set(category: category)
            switch category {
                case .fruits:
                    let fruits = newPath as! [Fruit]
                    fruits.forEach { path.append($0) }
                case .animals:
                    let animals = newPath as! [Animal]
                    animals.forEach { path.append($0) }
                default:
                    break
            }
        }

        mutating func push(_ newPath: AnyHashable) {
            if let animal = newPath as? Animal {
                path.append(animal)
                return
            }

            if let fruit = newPath as? Fruit {
                path.append(fruit)
                return
            }
        }
    }

    @Published var categories = Category.allCases
    @Published var selectedCategory: Category? = .fruits

    @Published var path: NavigationPath = NavigationPath()

    @Published var coordinator: Coordinator = Coordinator(category: .fruits, path: [])

    public func set(category: Category) {
        coordinator.set(category: category)
    }

    public func setPath(path newPath: AnyHashable...) {
        newPath.forEach {
            coordinator.push($0)
        }
    }

    public func set(path newPath: AnyHashable..., for category: Category) {
        coordinator.set(path: newPath, for: category)
        ////        coordinator.category = category
        //        set(category: category)
        //
        //        switch category {
        //            case .fruits:
        //                coordinator.setPath(newPath as! [Fruit])
        //            case .animals:
        //                coordinator.setPath(newPath as! [Animal])
        //            default:
        //                break
        //        }

    }

}
