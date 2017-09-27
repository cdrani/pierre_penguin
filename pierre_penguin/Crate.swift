//
//  Crate.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-27.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class Crate: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 40, height: 40)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var givesHeart = false
    var exploded = false
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
        
        // Only collide with ground and other crates:
        self.physicsBody?.collisionBitMask =
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.crate.rawValue
        self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
        
        self.texture = textureAtlas.textureNamed("crate")
    }
    
    // health crate
    func turnToHeartCrate() {
        self.physicsBody?.affectedByGravity = false
        self.texture = textureAtlas.textureNamed("crate-power-up")
        givesHeart = true
    }
    
    // exploding crate
    func explode() {
        // exit if exploded already:
        if exploded { return }
        exploded = true
        
        // prevent additional contact:
        self.physicsBody?.categoryBitMask = 0
    }
    
    // reset crated for reuse
    func reset() {
        self.alpha = 1
        self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
        exploded = false
    }
    
    func onTap() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
