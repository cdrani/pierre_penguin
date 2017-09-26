//
//  Coin.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-25.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class Coin: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 26, height: 26)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var value = 1
    
    init() {
        let bronzeTexture = textureAtlas.textureNamed("coin-bronze")
        super.init(texture: bronzeTexture, color: .clear, size: initialSize)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        
        // Monitor for contact events; prevent coin collisions with other objects
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
    
    func turnToGold() {
        self.texture = textureAtlas.textureNamed("coin-gold")
        self.value = 5
    }
    
    func onTap() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
