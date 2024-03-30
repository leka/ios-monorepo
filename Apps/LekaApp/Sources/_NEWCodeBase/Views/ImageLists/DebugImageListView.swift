// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import GameEngineKit
import SwiftUI

// MARK: - DebugImageListViewViewModel

class DebugImageListViewViewModel: ObservableObject {
    // MARK: Lifecycle

    init(images: [String]) {
        self.images = images
    }

    // MARK: Internal

    @Published var cellSize: CGFloat = 300
    @Published var cellState: GameplayChoiceState = .idle
    @Published var cellBackgroundColor: Color?
    @Published var images: [String]

    func getImageNameFromPath(path: String) -> String {
        let components = path.components(separatedBy: "/")
        return components.last ?? ""
    }

    func printImagesNames() {
        for (index, image) in self.images.enumerated() {
            print("image \(index + 1)")
            print("name: \(image)")
        }
    }

    func setState(to state: GameplayChoiceState) {
        self.cellState = state
    }

    func setBackgroundColor(to color: Color?) {
        self.cellBackgroundColor = color
    }

    func resizeWithAnimation(to size: CGFloat) {
        withAnimation {
            self.cellSize = size
        }
    }
}

// MARK: - DebugImageListView

struct DebugImageListView: View {
    // MARK: Lifecycle

    init(images: [String]) {
        self._viewModel = StateObject(wrappedValue: DebugImageListViewViewModel(images: images))
    }

    // MARK: Internal

    var body: some View {
        ScrollView {
            LazyVGrid(columns: self.columns, spacing: 20) {
                ForEach(self.viewModel.images, id: \.self) { imageName in
                    VStack(spacing: 20) {
                        ChoiceImageView(
                            image: imageName,
                            size: self.viewModel.cellSize,
                            background: self.viewModel.cellBackgroundColor,
                            state: self.viewModel.cellState
                        )

                        Text(self.viewModel.getImageNameFromPath(path: imageName))
                            .lineLimit(2, reservesSpace: true)
                            .multilineTextAlignment(.center)
                            .font(.caption)
                    }
                }
            }
            .frame(minWidth: 900)
            .padding()
        }
        .background(.lkBackground)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 0) {
                    Text("Background:")
                    Button("clear") { self.viewModel.setBackgroundColor(to: .clear) }
                    Button("⚪") { self.viewModel.setBackgroundColor(to: nil) }
                    Button("🔴") { self.viewModel.setBackgroundColor(to: .red) }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 0) {
                    Text("State:")
                    Button("idle") { self.viewModel.setState(to: .idle) }
                    Button("✅️") { self.viewModel.setState(to: .rightAnswer) }
                    Button("❌️") { self.viewModel.setState(to: .wrongAnswer) }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 0) {
                    Text("Size:")
                    Button("100") { self.viewModel.resizeWithAnimation(to: 100) }
                    Button("240") { self.viewModel.resizeWithAnimation(to: 240) }
                    Button("280") { self.viewModel.resizeWithAnimation(to: 280) }
                    Button("300") { self.viewModel.resizeWithAnimation(to: 300) }
                }
            }
        }
        .onAppear {
            self.viewModel.printImagesNames()
        }
    }

    // MARK: Private

    @StateObject private var viewModel: DebugImageListViewViewModel

    private let columns = Array(repeating: GridItem(), count: 3)
}

#Preview {
    NavigationSplitView {} detail: {
        NavigationStack {
            DebugImageListView(images: ContentKit.listRasterImages())
        }
    }
}
