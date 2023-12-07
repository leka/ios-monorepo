// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - InstructionButton

struct InstructionButton: View {
    @ObservedObject var gameMetrics: GameMetrics
    @EnvironmentObject var activityVM: ActivityViewModel

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Text(activityVM.steps[activityVM.currentStep].instruction.localized())
                .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                .font(.system(size: gameMetrics.instructionFontSize, weight: gameMetrics.instructionFontWeight))
                .multilineTextAlignment(.center)
                .padding(.horizontal, gameMetrics.instructionFrame.height)
            Spacer()
        }
        .frame(maxWidth: gameMetrics.instructionFrame.width)
        .frame(height: gameMetrics.instructionFrame.height, alignment: .center)
        .background(
            ZStack {
                Color.white
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.0), .black.opacity(0.0)]),
                    startPoint: .top, endPoint: .center
                )
                .opacity(activityVM.isSpeaking ? 1 : 0)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: gameMetrics.roundedCorner, style: .circular)
                .fill(
                    .clear,
                    strokeBorder: LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.2), .black.opacity(0.05)]), startPoint: .bottom,
                        endPoint: .top
                    ), lineWidth: 4
                )
                .opacity(activityVM.isSpeaking ? 0.5 : 0)
        )
        .overlay(
            HStack {
                Spacer()
                Image(
                    DesignKitAsset.Images.personTalking.name,
                    bundle: Bundle(for: DesignKitResources.self)
                )
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(
                    activityVM.isSpeaking
                        ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
                        : DesignKitAsset.Colors.progressBar.swiftUIColor
                )
                .padding(10)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: gameMetrics.roundedCorner, style: .circular))
        .shadow(
            color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor.opacity(0.2),
            radius: activityVM.isSpeaking ? 0 : 4, x: 0, y: activityVM.isSpeaking ? 1 : 4
        )
        .scaleEffect(activityVM.isSpeaking ? 0.98 : 1)
        .onTapGesture {
            activityVM.speak(sentence: activityVM.steps[activityVM.currentStep].instruction.localized())
        }
        .disabled(activityVM.isSpeaking)
        .animation(.easeOut(duration: 0.2), value: activityVM.isSpeaking)
    }
}

// MARK: - InstructionButton_Previews

struct InstructionButton_Previews: PreviewProvider {
    static var previews: some View {
        InstructionButton(gameMetrics: GameMetrics())
            .environmentObject(ActivityViewModel())
            .environmentObject(GameMetrics())
    }
}
