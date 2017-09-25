//
//  Player.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-24.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode, GameSprite {
    var initialSize: CGSize = CGSize(width: 64, height: 64)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Pierre")
    
    // Piere in Motion
    var flapping = false
    // Max upward force
    let maxFlappingForce: CGFloat = 57000
    // slow down when too high
    let maxHeight: CGFloat = 1000
    
    // Fly up and down animation
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        
        createAnimations()
        // "soarAnimation" key to reference action and action removal
        self.run(soarAnimation, withKey: "soarAnimation")
        
        // Create physics body based on third frame of Pierre's animation
        let bodyTexture = textureAtlas.textureNamed("pierre-flying-3")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: self.size)
        // fast loss of momentum
        self.physicsBody?.linearDamping = 0.9
        // weight of adult penguin 30kg
        self.physicsBody?.mass = 30
        // Prevent Pierre rotating:
        self.physicsBody?.allowsRotation = false
    }
    
    func createAnimations() {
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.8)
        rotateDownAction.timingMode = .easeIn
        
        // Create the flying animation
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("pierre-flying-1"),
            textureAtlas.textureNamed("pierre-flying-2"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-4"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-2")
        ]
        
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.03)
        
        // Group flying animation with rotate up
        flyAnimation = SKAction.group([
            SKAction.repeatForever(flyAction),
            rotateUpAction
        ])
        
        // Create the soaring animation
        let soarFrames:[SKTexture] = [textureAtlas.textureNamed("pierre-flying-1")]
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
        
        // Group soaring animation with rotate down
        soarAnimation = SKAction.group([
            SKAction.repeatForever(soarAction),
            rotateDownAction
        ])
    }
    
    func onTap() {
        
    }
    
    func update() {
        // if flapping, apply new force to push Pierre higher:
        if self.flapping {
            var forceToApply = maxFlappingForce
            
            // Apply less force if Pierre above position 600
            if position.y > 600 {
                // higher Pierre is --> more force removed
                let percentageOfMaxHeight = position.y / maxHeight
                let flappingForceSubtraction = percentageOfMaxHeight * maxFlappingForce
                forceToApply -= flappingForceSubtraction
            }
            
            // Apply final force
            self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
        }
        
        // Limit Pierre's top speed at ascension to prevent getting
        // enough momentum to climb past maxHeight
        if self.physicsBody!.velocity.dy > 300 {
            self.physicsBody!.velocity.dy = 300
        }
        
        // Set a constant velocity to the right:
        self.physicsBody?.velocity.dx = 200
    }
    
    func startFlapping() {
        self.removeAction(forKey: "soarAnimation")
        self.run(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    func stopFlapping() {
        self.removeAction(forKey: "flapAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
