//
//  InstructionView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 17/12/22.
//

// TODO(@ladislas): reimport when Down is fixed
// import Down
import SwiftUI

// FAKE DATA ===========================================================
// struct InstructionData: Identifiable {
//    var id = UUID()
//    var title: String
//    var instructions: String
// }
// FAKE DATA ===========================================================

struct InstructionsView: View {

	@EnvironmentObject var activityVM: ActivityViewModel
	@EnvironmentObject var metrics: UIMetrics

	// swiftlint:disable line_length
	// FAKE DATA ===========================================================
	//    @State private var instructionData: [InstructionData] =
	//    [
	//        InstructionData(title: "Objectif", instructions: "L'enfant doit associer l'image similaire à celle déjà présente dans le panier."),
	//        InstructionData(title: "Préparation de la séance", instructions: "1. Lancez la leçon en sélectionnant le bouton « GO ! » \n2. Sur l'écran, une image est déjà dans le panier et une autre est à l'extérieur du panier."),
	//        InstructionData(title: "Déroulé", instructions: "1. Incitez verbalement l'enfant à mettre dans le panier les mêmes images. \n2. Lorsque l'enfant met la bonne image dans le panier, Leka lance un renforçateur. **Renforcez socialement l'enfant** en même temps."),
	//        InstructionData(title: "Séquence", instructions: "Répétez le déroulé 5 fois"),
	//        InstructionData(title: "Validation de la leçon", instructions: "La leçon est valide lorsque **4 images sur les 5** ont été bien mises dans le panier.")
	//    ]
	// FAKE DATA ===========================================================
	// swiftlint:enable line_length

	var body: some View {
		ScrollView(.vertical, showsIndicators: true) {
			//			instructions_OLD
			instructionsMarkdownView
		}
		.safeAreaInset(edge: .top) {
			instructionTitle
		}
	}

	@ViewBuilder
	private var instructionsMarkdownView: some View {
		//		Text(activityVM.getInstructions())
		DownAttributedString(text: activityVM.getInstructions())
			//		MarkdownRepresentable(height: .constant(.zero))
			.environmentObject(MarkdownObservable(text: activityVM.getInstructions()))
			.padding()
			.frame(minWidth: 450, maxWidth: 550)
	}

	//	private var instructions_OLD: some View {
	//		VStack(alignment: .leading, spacing: 20) {
	//			ForEach(instructionData) { section in
	//				Text(section.title)
	//					.font(metrics.bold16)
	//				Text(.init(section.instructions))
	//					.font(metrics.reg14)
	//					.padding(.bottom, 22)
	//			}
	//		}
	//		.foregroundColor(Color("darkGray"))
	//		.padding()
	//		.frame(minWidth: 450, maxWidth: 550)
	//	}

	private var instructionTitle: some View {
		HStack {
			Spacer()
			Text("DESCRIPTION & INSTALLATION")
				.font(metrics.reg18)
				.foregroundColor(Color("darkGray").opacity(0.8))
				.padding(.vertical, 22)
			Spacer()
		}
		.padding(.top, 30)
		.background(Color("lekaLightGray"))
	}
}

struct InstructionsView_Previews: PreviewProvider {
	static var previews: some View {
		InstructionsView()
			.environmentObject(UIMetrics())
			.environmentObject(ActivityViewModel())
	}
}
