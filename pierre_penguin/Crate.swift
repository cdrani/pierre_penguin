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
    func explode(gameScene:GameScene) {
        // exit if exploded already:
        if exploded { return }
        exploded = true
        //Place crate explosion at this location:
        gameScene.particlePool.placeEmitter(node: self, emitterType: "crate")
        // Fade out crate sprit
        self.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
        
        if (givesHeart) {
            // award health:
            let newHealth = gameScene.player.health + 1
            let maxHealth = gameScene.player.maxHealth
            gameScene.player.health = newHealth > maxHealth ?
                maxHealth : newHealth
            
            // Place heart explostion here:
            gameScene.particlePool.placeEmitter(node: self, emitterType: "heart")
        } else {
            // coin reward
            gameScene.coinsCollected += 1
            gameScene.hud.setCoinCountDisplay(newCoinCount: gameScene.coinsCollected)
        }
        
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
