// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

@MainActor
class Navigation: ObservableObject {

    static let shared = Navigation()

    enum Category: CaseIterable, Identifiable {
        case home
        case activities
        case curriculums

        var id: Self { self }
    }

    @Published var categories = Category.allCases
    @Published var selectedCategory: Category? = .home

    @Published var mainPath: NavigationPath = NavigationPath() {
        willSet {
            print("WILL SET - mainPath: \(newValue)")
        }
        didSet {
            print("DID SET - mainPath: \(mainPath)")
        }
    }
//
//    var homeNavPath: NavigationPath = NavigationPath()
//    var activitiesNavPath: NavigationPath = NavigationPath(){
//        didSet {
//            print("DID SET - activitiesNavPath: \(activitiesNavPath)")
//        }
//    }
//    var curriculumsNavPath: NavigationPath = NavigationPath() {
//        didSet {
//            print("DID SET - curriculumsNavPath: \(curriculumsNavPath)")
//        }
//    }

    private var homeNavPathBackup: NavigationPath = NavigationPath()
    private var activitiesNavPathBackup: NavigationPath = NavigationPath()
    private var curriculumsNavPathBackup: NavigationPath = NavigationPath()

    private var cancellables = Set<AnyCancellable>()

    init() {
        $selectedCategory
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .pairwise()
            .sink { (previous, new) in
                print("\nChanged category: \(String(describing: previous )) --> \(new)")

                switch previous {
                    case .home:
                        self.homeNavPathBackup = self.mainPath
                        print("BACKUP homeNavPath \(self.homeNavPathBackup)")
                    case .activities:
                        self.activitiesNavPathBackup = self.mainPath
                        print("BACKUP activitiesNavPath \(self.activitiesNavPathBackup)")
                    case .curriculums:
                        self.curriculumsNavPathBackup = self.mainPath
                        print("BACKUP curriculumsNavPath \(self.curriculumsNavPathBackup)")
                    case .none:
                        break
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    switch new {
                        case .home:
                            self.mainPath = self.homeNavPathBackup
                            print("RESTORE homeNavPath: \(self.mainPath)")
                        case .activities:
                            self.mainPath = self.activitiesNavPathBackup
                            print("RESTORE activitiesNavPath: \(self.mainPath)")
                        case .curriculums:
                            self.mainPath = self.curriculumsNavPathBackup
                            print("RESTORE curriculumsNavPath: \(self.mainPath)")
                    }
                }
//                self.objectWillChange.send()

            }
            .store(in: &cancellables)
    }

    public func backToRoot() {
        mainPath = NavigationPath()
//        switch selectedCategory {
//            case .home:
//                mainPath = NavigationPath()
//            case .activities:
//                activitiesNavPath = NavigationPath()
//            case .curriculums:
//                curriculumsNavPath = NavigationPath()
//            case .none:
//                break
//        }
//        objectWillChange.send()
    }

}

extension Publisher {

    typealias Pairwise<T> = (previous: T?, current: T)

    /// Includes the current element as well as the previous element from the upstream publisher in a tuple where the previous element is optional.
    /// The first time the upstream publisher emits an element, the previous element will be `nil`.
    ///
    /// ```
    /// let range = (1...5)
    /// let subscription = range.publisher
    ///   .pairwise()
    ///   .sink { print("(\($0.previous), \($0.current))", terminator: " ") }
    /// ```
    /// Prints: "(nil, 1) (Optional(1), 2) (Optional(2), 3) (Optional(3), 4) (Optional(4), 5)".
    ///
    /// - Returns: A publisher of a tuple of the previous and current elements from the upstream publisher.
    ///
    /// - Note: Based on <https://stackoverflow.com/a/67133582/3532505>.
    func pairwise() -> AnyPublisher<Pairwise<Output>, Failure> {
        // `scan()` needs an initial value, which is `nil` in our case.
        // Therefore we have to return an optional here and use `compactMap()` below the remove the optional type.
        scan(nil) { previousPair, currentElement -> Pairwise<Output>? in
            Pairwise(previous: previousPair?.current, current: currentElement)
        }
        .compactMap { $0 }
        .eraseToAnyPublisher()
    }
    
}
