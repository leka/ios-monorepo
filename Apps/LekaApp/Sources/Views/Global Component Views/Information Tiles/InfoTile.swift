//
//  InfoTile.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 10/1/23.
//

import SwiftUI

struct InfoTile: View {
    
    @EnvironmentObject var settings: SettingsViewModel
	@EnvironmentObject var sidebar: SidebarViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics:  UIMetrics
    
    let data: TileData
    private var headerColor: Color {
        return data == .discovery ? Color("lekaOrange") : Color.accentColor
    }
    
    var body: some View {
        VStack(spacing: 0) {
            tileHeader
            tileContent
            Spacer()
        }
        .frame(height: 266)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: metrics.tilesRadius, style: .continuous))
    }
	
	private var tileHeader: some View {
		ZStack {
			Text(data.content.title!)
			HStack {
				if data == .discovery {
					Image(systemName: "exclamationmark.triangle")
						.font(metrics.semi20)
				} else {
					Image(data.content.image!)
						.resizable()
						.renderingMode(.template)
						.aspectRatio(contentMode: .fit)
				}
				Spacer()
				if data != .discovery && settings.companyIsConnected {
					closeButton
				}
			}
			.padding(.vertical, 6)
			.padding(.horizontal, 20)
		}
		.font(metrics.semi17)
		.frame(height: 44)
		.foregroundColor(.white)
		.background(headerColor)
	}
	
	private var tileContent: some View {
		VStack {
			Spacer()
			Text(data.content.subtitle!)
				.font(metrics.reg17)
				.foregroundColor(headerColor)
			Spacer()
			Text(data.content.message!)
				.font(metrics.reg13)
			Spacer()
			if data == .discovery  {
				connectButton
			}
		}
		.multilineTextAlignment(.center)
		.frame(maxWidth: 300)
		.foregroundColor(.accentColor)
	}
	
	private var closeButton: some View {
		Button {
			sidebar.updateShowInfo()
		} label: {
			Image(systemName: "multiply")
				.font(metrics.semi20)
		}
	}
	
	private var connectButton: some View {
		Button {
			viewRouter.currentPage = .welcome
		} label: {
			Text(data.content.CTALabel!)
		}
		.padding(20)
		.buttonStyle(BorderedCapsule_NoFeedback_ButtonStyle(font: metrics.reg17,
															color: .accentColor,
															width: 300))
	}
}

struct InfoTile_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.teal.ignoresSafeArea()
            InfoTile(data: .discovery)
                .environmentObject(SettingsViewModel())
				.environmentObject(SidebarViewModel())
                .environmentObject(UIMetrics())
                .environmentObject(ViewRouter())
                .padding()
        }
    }
}
