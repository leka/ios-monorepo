// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

extension DanceFreeze {
    struct LauncherView: View {
        @ObservedObject var viewModel: MainViewViewModel
        @Binding var mode: Stage
        @Binding var motion: Motion

        var body: some View {
            VStack(spacing: 70) {
                HStack(spacing: 70) {
                    GameEngineKitAsset.Exercises.DanceFreeze.imageIllustration.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 50)

                    VStack(spacing: 15) {
                        HStack(spacing: 40) {
                            VStack(spacing: 0) {
                                MotionModeButtonStyle(
                                    image: GameEngineKitAsset.Exercises.DanceFreeze.iconMotionModeRotation.swiftUIImage,
                                    color: motion == .rotation ? .teal : .gray)
                                Text("Rotation")
                            }
                            .foregroundStyle(motion == .rotation ? .teal : .gray.opacity(0.4))

                            Toggle(
                                "",
                                isOn: Binding<Bool>(
                                    get: { self.motion == .movement },
                                    set: { self.motion = $0 ? .movement : .rotation }
                                )
                            )
                            .toggleStyle(BinaryChoiceToggleStyle())

                            VStack(spacing: 0) {
                                MotionModeButtonStyle(
                                    image: GameEngineKitAsset.Exercises.DanceFreeze.iconMotionModeMovement.swiftUIImage,
                                    color: motion == .movement ? .teal : .gray)
                                Text("Mouvement")
                            }
                            .foregroundStyle(motion == .movement ? .teal : .gray.opacity(0.4))
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                        SongSelectorView(viewModel: viewModel)
                            .frame(maxHeight: 260)
                    }
                    .frame(maxWidth: 460, maxHeight: 400)
                }
                .padding(.horizontal, 100)

                HStack(spacing: 70) {
                    Button {
                        mode = .manualMode
                    } label: {
                        StageModeButtonStyle("Jouer - Mode manuel", color: .cyan)
                    }

                    Button {
                        mode = .automaticMode
                    } label: {
                        StageModeButtonStyle("Jouer - Mode auto", color: .mint)
                    }
                }
            }
        }
    }
}

#Preview {
    let songs = [
        AudioRecording(name: "Giggly Squirrel", file: "Giggly_Squirrel"),
        AudioRecording(name: "Empty Page", file: "Empty_Page"),
        AudioRecording(name: "Early Bird", file: "Early_Bird"),
        AudioRecording(name: "Hands On", file: "Hands_On"),
        AudioRecording(name: "In The Game", file: "In_The_Game"),
        AudioRecording(name: "Little by Little", file: "Little_by_little"),
    ]
    @StateObject var viewModel = DanceFreeze.MainViewViewModel(songs: songs)

    return DanceFreeze.LauncherView(
        viewModel: viewModel,
        mode: .constant(.waitingForSelection),
        motion: .constant(.rotation)
    )
}
