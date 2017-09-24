//
//  Bee.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-24.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

// Create Bee class, inheriting from SKSpriteNode
// and adopting the GameSprite protocol:
class Bee: SKSpriteNode, GameSprite {
    // store size, texture atlass, animations as class wide properties
    var initialSize: CGSize = CGSize(width: 28, height: 24)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    // init func called when Bee in instantiated
    init() {
        // Call init func on base class (SKSpriteNode)
        // Pass nil for texture ---> animate manually
        super.init(texture: nil, color: .clear, size: initialSize)
        
        // Create and run the flying animation
        createAnimations()
        self.run(flyAnimation)
    }
    
    func createAnimations() {
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("bee"),
            textureAtlas.textureNamed("bee-fly")
        ]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    
    // touch events
    func onTap() {
        
    }
    
    // subclass SKSpriteNode
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
