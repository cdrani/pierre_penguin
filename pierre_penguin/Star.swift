//
//  Star.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-25.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class Star: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 40, height: 38)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var pulseAnimation = SKAction()
    
    init() {
        let starTexture = textureAtlas.textureNamed("star")
        super.init(texture: starTexture, color: .clear, size: initialSize)
        
        // Assign physic body:
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        
        // star animation:
        createAnimations()
        self.run(pulseAnimation)
        
        // Powerup physics category
        self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
    }
    
    func createAnimations() {
        // Scale star down and slight fade out:
        let pulseOutGroup = SKAction.group([
            SKAction.fadeAlpha(to: 0.85, duration: 0.8),
            SKAction.scale(to: 0.6, duration: 0.8),
            SKAction.rotate(byAngle: -0.3, duration: 0.8)
        ])
        
        // Scale star up and fade back in:
        let pulseInGroup = SKAction.group([
            SKAction.fadeAlpha(to: 1, duration: 1.5),
            SKAction.scale(to: 1, duration: 1.5),
            SKAction.rotate(byAngle: 3.5, duration: 1.5)
        ])
        
        // Combine pulses in sequence group:
        let pulseSequence = SKAction.sequence([pulseOutGroup, pulseInGroup])
        pulseAnimation = SKAction.repeatForever(pulseSequence)
    }
    
    func onTap() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
