//
//  UIDataVM.swift
//  Leka Emotion
//
//  Created by Mathieu Jeannot on 22/6/22.
//

import Foundation
import SwiftUI

class GameMetrics: NSObject, ObservableObject {
    
    // MARK: - Views Metrics & Animations parameters
    // GameView
    @Published var headerTotalHeight: CGFloat = 155
    @Published var headerSpacing: CGFloat = 40
    @Published var headerPadding: CGFloat = 30
    @Published var instructionFontSize: CGFloat = 22
    @Published var instructionFontWeight: Font.Weight = .regular
    @Published var instructionFrame: CGSize = CGSize(width: 640, height: 85)
	@Published var reg17: Font = .system(size: 17, weight: .regular)
	@Published var semi17: Font = .system(size: 17, weight: .semibold)
	
	// Lottie Screens
    @Published var motivatorScale: CGFloat = 1.2
    @Published var endAnimTextsSpacing : CGFloat = 40
    @Published var endAnimFontSize: CGFloat = 30
    @Published var endAnimFontWeight: Font.Weight = .black
    @Published var endAnimFontDesign: Font.Design = .rounded
    @Published var endAnimDuration: Double = 0.6
    @Published var endAnimDelayTop: Double = 1.2
    @Published var endAnimDelayBottom: Double = 1.0
    @Published var endAnimBtnDuration: Double = 0.25
    @Published var endAnimGameOverBtnDelay: Double = 1.6
    @Published var endAnimReplayBtnDelay: Double = 1.7
    @Published var endAnimBtnPadding: CGFloat = 80
    
    // ProgressView
    @Published var stepMarkerBorderWidth: CGFloat = 3
//    @Published var stepMarkerDiameter: CGFloat = 18
    @Published var stepMarkerPadding: CGFloat = 6
    @Published var progressViewHeight: CGFloat = 30
    
    // PlayZone
    @Published var playGridBtnCellSize: CGFloat = 250
    @Published var playGridBtnSize: CGFloat = 200
    @Published var playGridRowSpacing: CGFloat = 26
    @Published var playGridBtnTrimLineWidth: CGFloat = 6
    @Published var playGridBtnAnimDuration: Double = 0.3
    
    // Misc
    @Published var roundedCorner: CGFloat = 10

}

