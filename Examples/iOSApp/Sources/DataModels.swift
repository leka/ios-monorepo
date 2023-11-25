// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct Fruit: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var subFruits: [Fruit]?
}

let fruits: [Fruit] = [
    Fruit(name: "Apple", subFruits: [Fruit(name: "Granny Smith"), Fruit(name: "Pink Lady")]),
    Fruit(name: "Banana", subFruits: [Fruit(name: "Cavendish"), Fruit(name: "Lady Finger")]),
    Fruit(name: "Orange", subFruits: nil),
    Fruit(name: "Strawberry", subFruits: nil),
]

struct Animal: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var friends: [Animal]?
}

let animals: [Animal] = [
    Animal(name: "Cat", friends: [Animal(name: "Garfield"), Animal(name: "Felix")]),
    Animal(name: "Dog", friends: [Animal(name: "Snoopy"), Animal(name: "Pluto")]),
    Animal(name: "Pig", friends: nil),
    Animal(name: "Cow", friends: nil),
]
