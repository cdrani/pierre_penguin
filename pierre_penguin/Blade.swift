//
//  Blade.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-25.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class Blade: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 185, height: 92)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var spinAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        let startTexture = textureAtlas.textureNamed("blade")
        self.physicsBody = SKPhysicsBody(texture: startTexture, size: initialSize)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        createAnimations()
        self.run(spinAnimation)
        
        // Collisons with player
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        // Remove damagedPenguin physics category from collisions with enemies
        // Allows change of penguins physics catergory to damagedPenguin value
        // when damage should be ignored in collisions with enemeies (powerup star)
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
    }
    
    func createAnimations() {
        let spinFrames: [SKTexture] = [
            textureAtlas.textureNamed("blade"),
            textureAtlas.textureNamed("blade-2")
        ]
        let spinAction = SKAction.animate(with: spinFrames, timePerFrame: 0.07)
        spinAnimation = SKAction.repeatForever(spinAction)
    }
    
    func onTap() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
