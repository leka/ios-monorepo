// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import MarkdownUI
import SwiftUI

// MARK: - ActivityListView

struct ActivityListView: View {
    let activities: [Activity] = ContentKit.listSampleActivities() ?? []
    let pngImages: [String] = ContentKit.listImagesPNG()

    var body: some View {
        List {
//            ForEach(self.activities) { activity in
//                NavigationLink(destination: ActivityDetailsView(activity: activity)) {
//                    Image(uiImage: activity.details.iconImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 44, height: 44)
//                    Text(activity.name)
//                }
//            }

            ForEach(self.pngImages, id: \.self) { image in
                VStack {
                    Image(uiImage: UIImage(named: image)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    Text(self.getImageNameFromPath(path: image))
                }
            }
        }
        .navigationTitle("Activities")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("240") {
                    print("Refresh")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("280") {
                    print("Refresh")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("300") {
                    print("Refresh")
                }
            }
        }
        .onAppear {
            let skills = Skills.list
            for (index, skill) in skills.enumerated() {
                print("skill \(index + 1)")
                print("id: \(skill.id)")
                print("name: \(skill.name)")
                print("description: \(skill.description)")
            }

            let hmis = HMI.list
            for (index, hmi) in hmis.enumerated() {
                print("hmi \(index + 1)")
                print("id: \(hmi.id)")
                print("name: \(hmi.name)")
                print("description: \(hmi.description)")
            }

            let authors = Authors.list
            for (index, author) in authors.enumerated() {
                print("author \(index + 1)")
                print("id: \(author.id)")
                print("name: \(author.name)")
                print("description: \(author.description)")
            }

            let images = ContentKit.listImagesPNG()
            for (index, image) in images.enumerated() {
                print("image \(index + 1)")
                print("name: \(image)")
            }
        }
    }

    func getImageNameFromPath(path: String) -> String {
        let components = path.components(separatedBy: "/")
        return components.last ?? ""
    }
}

#Preview {
    NavigationStack {
        ActivityListView()
    }
}
