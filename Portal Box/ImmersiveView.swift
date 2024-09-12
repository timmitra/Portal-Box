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

@MainActor
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
               //box.position = [0, 1, -2] // meters
                box.scale = [1, 2, 1]
                
                // make world
                let world1 = Entity()
                world1.components.set(WorldComponent())
                let skybox1 = await createSkyboxEntity(texture: "skybox1")
                content.add(skybox1)
            }
        }
    }
    
    func createSkyboxEntity(texture: String) async -> Entity {
        guard let resource = try? await TextureResource(named: texture) else {
            fatalError("unable to make skybox")
        }
        var material = UnlitMaterial()
        material.color = .init(texture: .init(resource))
        let entity = Entity()
        entity.components.set(ModelComponent(mesh: .generateSphere(radius: 1000), materials: [material]))
        entity.scale *= .init(x: -1, y:1, z:1)
        return entity
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
