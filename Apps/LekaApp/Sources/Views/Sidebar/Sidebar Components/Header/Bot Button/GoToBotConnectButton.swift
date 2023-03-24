//
//  GoToBotConnectButton.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 17/12/22.
//

import SwiftUI

struct GoToBotConnectButton: View {

    @EnvironmentObject var botVM: BotViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Button {
            viewRouter.currentPage = .bots
        } label: {
            HStack(spacing: 10) {
				BotConnectionIndicator()
				ButtonContent
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(10)
            .frame(height: 100)
        }
        .contentShape(Rectangle())
    }

	@ViewBuilder
	private var ButtonContent: some View {
		if botVM.botIsConnected {
			VStack(alignment: .leading, spacing: 4) {
				Text("Connecté à")
				Text(botVM.currentlyConnectedBotName)
					.font(metrics.reg16)
				HStack(spacing: 4) {
					BotBatteryIndicator(level: $botVM.botChargeLevel,
										charging: $botVM.botIsCharging)
					Text(botVM.botOSVersion)
						.foregroundColor(Color("darkGray"))
				}
			}
			.font(metrics.reg12)
			.foregroundColor(.accentColor)
		} else {
			Text("Connectez vous à votre LEKA.")
				.font(metrics.reg16)
				.foregroundColor(.accentColor)
		}
	}
}
