//
//  ProgressBarView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 24/11/22.
//

import SwiftUI

struct ProgressBarView: View {

	@EnvironmentObject var activityVM: ActivityViewModel
	@ObservedObject var gameMetrics: GameMetrics

    @ViewBuilder
    func stepMarker(_ color: Color) -> some View {
        Circle()
            .fill(color,
                  strokeBorder: .white,
				  lineWidth: gameMetrics.stepMarkerBorderWidth)
            .background(Circle().fill(.white))
			.padding(gameMetrics.stepMarkerPadding)
    }

    var body: some View {
        Capsule()
            .fill(Color("progressBar"))
			.frame(maxHeight: gameMetrics.progressViewHeight)
            .frame(maxWidth: 760) // this will change
            .overlay(
                HStack(spacing: 0) {
                    ForEach(activityVM.steps.indices, id: \.self) { index in
						stepMarker(activityVM.markerColors[index])
						if index < activityVM.markerColors.count-1 {
                            Spacer()
                        }
                    }
                }
            )
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
		ProgressBarView(gameMetrics: GameMetrics())
			.environmentObject(ActivityViewModel())
    }
}
