//
//  MadFly.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-25.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class MadFly: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 61, height: 29)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        self.physicsBody?.affectedByGravity = false
        createAnimations()
        self.run(flyAnimation)
        
        // Collisons with player
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        // Remove damagedPenguin physics category from collisions with enemies
        // Allows change of penguins physics catergory to damagedPenguin value
        // when damage should be ignored in collisions with enemeies (powerup star)
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
    }
    
    func createAnimations() {
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("madfly"),
            textureAtlas.textureNamed("madfly-fly")
        ]
        
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    
    func onTap() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
