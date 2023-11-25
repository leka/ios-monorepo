// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct FruitsDetailView: View {

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

    @EnvironmentObject var navigation: Navigation

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
                navigation.path.append(fruits[0])
                navigation.path.append(fruits[1])
            }

        }
        .navigationDestination(for: Fruit.self) { fruit in
            VStack(spacing: 20) {
                FruitInfoView(fruit: fruit)
                Text("Current path: \(String(describing: navigation.path))")
            }
            .navigationTitle("\(fruit.name)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.teal)
    }
}

struct AnimalsDetailView: View {

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
                Text("Current path: \(String(describing: navigation.path))")
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
                Button("Go to Fruits/Apple") {
                    navigation.selectedCategory = .fruits
                    // ? Not working
                    // navigation.path.append(fruits[0])
                    // ? Current workaround
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        navigation.path.append(fruits[1])
                    }
                }

                Button("Go to Animals/Dog") {
                    navigation.selectedCategory = .animals
                    // ? Not working
                    // navigation.path.append(animals[1])
                    // ? Current workaround
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        navigation.path.append(animals[1])
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.mint)
    }
}
