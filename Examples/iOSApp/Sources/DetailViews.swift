// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FruitInfoView: View {
    let fruit: Fruit

    var body: some View {
        VStack {
            Text("Info view for **\(fruit.name)**")

            VStack {
                ForEach(fruit.subFruits ?? []) { subFruit in
                    NavigationLink(value: subFruit) {
                        Text(subFruit.name)
                    }
                }
            }
        }
    }
}

struct AnimalInfoView: View {
    let animal: Animal

    var body: some View {
        VStack {
            Text("Info view for **\(animal.name)**")

            VStack {
                ForEach(animal.friends ?? []) { friend in
                    NavigationLink(value: friend) {
                        Text(friend.name)
                    }
                }
            }
        }
    }
}

struct FruitsDetailView: View {

    //    @EnvironmentObject var navigation: Navigation

    var navigation = Navigation.shared

    var body: some View {
        VStack(spacing: 50) {
            Text("Hello, you're now in **Fruits**")
                .foregroundColor(.white)
                .font(.title)

            VStack(spacing: 20) {
                ForEach(fruits) { fruit in
                    NavigationLink(value: fruit) {
                        Text(fruit.name)
                    }
                }
            }
            Button("Go to Apple/Banana") {

                //                navigation.path.append(fruits[0])
                //                navigation.path.append(fruits[1])
                navigation.set(path: fruits[0], fruits[1], for: .fruits)
            }

        }
        .navigationDestination(for: Fruit.self) { fruit in
            VStack(spacing: 20) {
                FruitInfoView(fruit: fruit)
            }
            .navigationTitle("\(fruit.name)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.teal)
    }
}

struct AnimalsDetailView: View {

    @EnvironmentObject var navigation: Navigation

    var body: some View {
        VStack(spacing: 50) {
            Text("Hello, you're now in **Animals**")
                .foregroundColor(.white)
                .font(.title)

            VStack(spacing: 20) {
                ForEach(animals) { animal in
                    NavigationLink(value: animal) {
                        Text(animal.name)
                    }
                }
            }
            Button("Go to Cat/Dog") {
                navigation.path.append(animals[0])
                navigation.path.append(animals[1])
            }

        }
        .navigationDestination(for: Animal.self) { animal in
            VStack(spacing: 20) {
                AnimalInfoView(animal: animal)
            }
            .navigationTitle("\(animal.name)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.orange)
    }
}

struct ActionsDetailView: View {

    @EnvironmentObject var navigation: Navigation

    var body: some View {
        VStack(spacing: 50) {
            Text("Hello, you're now in **Actions**")
                .foregroundColor(.white)
                .font(.title)

            VStack(spacing: 20) {
                Button("Go to Category:Fruits - Apple") {
                    navigation.set(path: fruits[1], for: .fruits)
                    //                    navigation.selectedCategory = .fruits
                    //                    // ? Not working
                    //                    // navigation.path.append(fruits[0])
                    //                    // ? Current workaround
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    //                        navigation.path.append(fruits[1])
                    //                    }
                }

                Button("Go to Category:Animals - Dog") {
                    navigation.selectedCategory = .animals
                    navigation.set(category: .animals)
                    // ? Not working
                    // navigation.path.append(animals[1])
                    // ? Current workaround
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        navigation.path.append(animals[1])
                        navigation.setPath(path: animals[1])
                    }
                }

                Button("Go to Category:Actions - Cat/Apple/Dog/Banana") {
                    navigation.setPath(path: animals[0], fruits[0], animals[1], fruits[1])
                }
            }
        }
        .navigationDestination(for: Animal.self) { animal in
            VStack(spacing: 20) {
                AnimalInfoView(animal: animal)
            }
            .navigationTitle("\(animal.name)")
        }
        .navigationDestination(for: Fruit.self) { fruit in
            VStack(spacing: 20) {
                FruitInfoView(fruit: fruit)
            }
            .navigationTitle("\(fruit.name)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.mint)
    }
}
