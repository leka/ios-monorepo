// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - InstructionButtonDeprecated

struct InstructionButtonDeprecated: View {
    @ObservedObject var gameMetrics: GameMetrics
    @EnvironmentObject var activityVM: ActivityViewModelDeprecated

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            Text(self.activityVM.steps[self.activityVM.currentStep].instruction.localized())
                .foregroundColor(DesignKitAsset.Colors.lekaDarkGray.swiftUIColor)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, self.gameMetrics.instructionFrame.height)
            Spacer()
        }
        .frame(maxWidth: self.gameMetrics.instructionFrame.width)
        .frame(height: self.gameMetrics.instructionFrame.height, alignment: .center)
        .background(
            ZStack {
                Color.white
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.1), .black.opacity(0.0), .black.opacity(0.0)]),
                    startPoint: .top, endPoint: .center
                )
                .opacity(self.activityVM.isSpeaking ? 1 : 0)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: self.gameMetrics.roundedCorner, style: .circular)
                .fillDeprecated(
                    .clear,
                    strokeBorder: LinearGradient(
                        gradient: Gradient(colors: [.black.opacity(0.2), .black.opacity(0.05)]), startPoint: .bottom,
                        endPoint: .top
                    ), lineWidth: 4
                )
                .opacity(self.activityVM.isSpeaking ? 0.5 : 0)
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
                    self.activityVM.isSpeaking
                        ? DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
                        : DesignKitAsset.Colors.progressBar.swiftUIColor
                )
                .padding(10)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: self.gameMetrics.roundedCorner, style: .circular))
        .shadow(
            color: DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor.opacity(0.2),
            radius: self.activityVM.isSpeaking ? 0 : 4, x: 0, y: self.activityVM.isSpeaking ? 1 : 4
        )
        .scaleEffect(self.activityVM.isSpeaking ? 0.98 : 1)
        .onTapGesture {
            self.activityVM.speak(sentence: self.activityVM.steps[self.activityVM.currentStep].instruction.localized())
        }
        .disabled(self.activityVM.isSpeaking)
        .animation(.easeOut(duration: 0.2), value: self.activityVM.isSpeaking)
    }
}

// MARK: - InstructionButton_Previews

struct InstructionButton_Previews: PreviewProvider {
    static var previews: some View {
        InstructionButtonDeprecated(gameMetrics: GameMetrics())
            .environmentObject(ActivityViewModelDeprecated())
            .environmentObject(GameMetrics())
    }
}
