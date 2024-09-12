//
// ---------------------------- //
// Original Project: Portal Box
// Created on 2024-09-12 by Tim Mitra
// Mastodon: @timmitra@mastodon.social
// Twitter/X: timmitra@twitter.com
// Web site: https://www.it-guy.com
// ---------------------------- //
// Copyright © 2024 iT Guy Technologies. All rights reserved.


import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @State private var box = Entity()

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let portalBoxScene = try? await Entity(named: "PortalBoxScene", in: realityKitContentBundle) {
                
                content.add(portalBoxScene)

                guard let box = portalBoxScene.findEntity(named: "Box") else {
                    return
                }
                self.box = box
              // box.position = [0, 1, -1.5] // meters
                box.scale = [1, 2, 1]
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
