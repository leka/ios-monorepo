//
//  GoToProfileEditorButton.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 17/12/22.
//

import SwiftUI

struct GoToProfileEditorButton: View {
    
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var metrics: UIMetrics
    
    var body: some View {
        Button {
            if settings.exploratoryModeIsOn {
                settings.showSwitchOffExploratoryAlert.toggle()
            } else {
                viewRouter.currentPage = .profiles
            }
        } label: {
            VStack(spacing: 5) {
                HStack(alignment: .top) {
                    Spacer()
                    SidebarAvatarCell(type: .teacher)
                    SidebarAvatarCell(type: .user, badge: !settings.companyIsConnected)
                    Spacer()
                }
                .overlay( TickPic() )
                
                if settings.exploratoryModeIsOn {
					exploratoryModeLabel
                }
            }
        }
        .frame(minHeight: 135)
        .contentShape(Rectangle())
        .animation(.default, value: settings.exploratoryModeIsOn)
    }
	
	private var exploratoryModeLabel: some View {
		Text("Mode exploratoire")
			.font(metrics.reg17)
			.foregroundColor(Color("lekaSkyBlue"))
			.padding(.vertical, 2)
			.padding(.horizontal, 6)
			.background(.white, in: RoundedRectangle(cornerRadius: metrics.btnRadius))
	}
}


struct GoToProfileEditorButton_Previews: PreviewProvider {
    static var previews: some View {
        GoToProfileEditorButton()
            .environmentObject(CompanyViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(UIMetrics())
    }
}
