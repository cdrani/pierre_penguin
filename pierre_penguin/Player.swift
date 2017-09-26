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
    
    // Player health properties
    var health:Int = 3
    // Only invulnerable with powerup star
    var invulnerable = false
    var damaged = false
    // Animations for when player takes damage or dies
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    // Stop forward velocity when player dies
    var forwardVelocity:CGFloat = 200
    
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
        
        // Penguin physics category --> for collisions
        self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
        self.physicsBody?.contactTestBitMask =
            PhysicsCategory.enemy.rawValue |
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.powerup.rawValue |
            PhysicsCategory.coin.rawValue
        
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
        
        // Momentary relaxation of gravity:
        self.physicsBody?.affectedByGravity = false
        // Add some slight upward velocity:
        self.physicsBody?.velocity.dy = 80
        // Start gravity after slight delay:
        let startGravitySequence = SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.run{
                self.physicsBody?.affectedByGravity = true
            }
            ])
        self.run(startGravitySequence)
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
        
        // --- Taking Damage Animation ---
        let damageStart = SKAction.run {
            // player should pass through enemies:
            self.physicsBody?.categoryBitMask = PhysicsCategory.damagedPenguin.rawValue
        }
        // Opacity pulse, slow then fast at the end:
        let slowFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.35),
            SKAction.fadeAlpha(to: 0.7, duration: 0.35)
            ])
        
        let fastFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.2),
            SKAction.fadeAlpha(to: 0.7, duration: 0.2)
            ])
        
        let fadeOutAndIn = SKAction.sequence([
            SKAction.repeat(slowFade, count: 2),
            SKAction.repeat(fastFade, count: 5)
            ])
        
        // Return player to normal
        let damageEnd = SKAction.run {
            self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
            // turn off damaged flag:
            self.damaged = false
        }
        
        self.damageAnimation = SKAction.sequence([
            damageStart,
            fadeOutAndIn,
            damageEnd
            ])
        
        // --- Death Animation ---
        let startDie = SKAction.run {
            // Death texture:
            self.texture = self.textureAtlas.textureNamed("pierre-dead")
            // Suspend player in space and stop any movement:
            self.physicsBody?.affectedByGravity = false
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        let endDie = SKAction.run {
            self.physicsBody?.affectedByGravity = true
        }
        
        self.dieAnimation = SKAction.sequence([
            startDie,
            // Enlarge penguin:
            SKAction.scale(to: 1.3, duration: 0.5),
            // short pause
            SKAction.wait(forDuration: 0.5),
            // rotate player on back
            SKAction.rotate(byAngle: 3, duration: 1.5),
            SKAction.wait(forDuration: 0.5),
            endDie
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
        self.physicsBody?.velocity.dx = self.forwardVelocity
    }
    
    func startFlapping() {
        // Prevent flying if dead
        if self.health <= 0 { return }
        
        self.removeAction(forKey: "soarAnimation")
        self.run(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    func stopFlapping() {
        // Prevent flying if dead
        if self.health <= 0 { return }
        
        self.removeAction(forKey: "flapAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
    func die() {
        // Player should be visible:
        self.alpha = 1
        // Remove all animations:
        self.removeAllActions()
        // Run die aniation:
        self.run(dieAnimation)
        // Stop moving forward:
        self.forwardVelocity = 0
    }
    
    func takeDamage() {
        if self.invulnerable || self.damaged { return }
        // player hit:
        self.damaged = true
        
        // Remove some health:
        self.health -= 1
        if self.health == 0 {
            // Out of health
            die()
        } else {
            // Damage animation:
            self.run(damageAnimation)
        }
    }
    
    func starPower() {
        // Remove existing powerup animation when player under powerup
        self.removeAction(forKey: "starPower")
        // star powers:
        self.forwardVelocity = 400
        self.invulnerable = true
        
        // star powerup lasts 8 secs; slight scaling to show powerup in effect:
        let startSequence = SKAction.sequence([
            SKAction.scale(to: 1.5, duration: 0.3),
            SKAction.wait(forDuration: 8),
            SKAction.scale(to: 1, duration: 1),
            SKAction.run {
                self.forwardVelocity = 200
                self.invulnerable = false
            }
            ])
        
        self.run(startSequence, withKey: "starPower")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
