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
              // box.position = [0, 1, -2] // meters
                box.scale = [1, 1, 1]
                
                // make 4 worlds
                let world1 = Entity()
                world1.components.set(WorldComponent())
                let skybox1 = await createSkyboxEntity(texture: "skybox1")
                world1.addChild(skybox1)
                content.add(world1)
                
                let world2 = Entity()
                world2.components.set(WorldComponent())
                let skybox2 = await createSkyboxEntity(texture: "skybox2")
                world2.addChild(skybox2)
                content.add(world2)
                
                let world3 = Entity()
                world3.components.set(WorldComponent())
                let skybox3 = await createSkyboxEntity(texture: "skybox3")
                world3.addChild(skybox3)
                content.add(world3)
                
                let world4 = Entity()
                world4.components.set(WorldComponent())
                let skybox4 = await createSkyboxEntity(texture: "skybox4")
                world1.addChild(skybox4)
                content.add(world4)
                
                /// make 4 portals
                /// portal 1
                let worldPortal1 = createPortal(target: world1)
                content.add(worldPortal1)
                
                guard let anchorPortal1 = portalBoxScene.findEntity(named: "AnchorPortal1") else {
                    fatalError("couldn't make anchorPortal1")
                }
                anchorPortal1.addChild(worldPortal1)
                worldPortal1.transform.rotation = simd_quatf(angle: .pi/2, axis: [1,0,0])

                /// portal 2
                let worldPortal2 = createPortal(target: world2)
                content.add(worldPortal2)
                
                guard let anchorPortal2 = portalBoxScene.findEntity(named: "AnchorPortal2") else {
                    fatalError("couldn't make anchorPortal2")
                }
                anchorPortal2.addChild(worldPortal2)
                worldPortal2.transform.rotation = simd_quatf(angle: -.pi/2, axis: [1,0,0])

                /// portal 3
                let worldPortal3 = createPortal(target: world3)
                content.add(worldPortal3)
                
                guard let anchorPortal3 = portalBoxScene.findEntity(named: "AnchorPortal3") else {
                    fatalError("couldn't make anchorPortal3")
                }
                anchorPortal3.addChild(worldPortal3)
                let portal3RotX = simd_quatf(angle: .pi/2, axis: [1,0,0])
                let portal3RotY = simd_quatf(angle: -.pi/2, axis: [0,1,0])
                worldPortal3.transform.rotation = portal3RotY * portal3RotX // order matters

                /// portal 4
                let worldPortal4 = createPortal(target: world4)
                content.add(worldPortal4)
                
                guard let anchorPortal4 = portalBoxScene.findEntity(named: "AnchorPortal4") else {
                    fatalError("couldn't make anchorPortal4")
                }
                anchorPortal4.addChild(worldPortal4)
                let portal4RotX = simd_quatf(angle: .pi/2, axis: [1,0,0])
                let portal4RotY = simd_quatf(angle: .pi/2, axis: [0,1,0])
                worldPortal4.transform.rotation = portal4RotY * portal4RotX
                
                 
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
    
    func createPortal(target: Entity) -> Entity {
        let portalMesh = MeshResource.generatePlane(width: 1, depth: 1)
        let portal = ModelEntity(mesh: portalMesh, materials: [PortalMaterial()])
        portal.components.set(PortalComponent(target: target))
        return portal
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
