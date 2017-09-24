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
    
    // Fly up and down animation
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear, size: initialSize)
        
        createAnimations()
        // "flapAnimation" key to reference action and action removal
        self.run(flyAnimation, withKey: "flapAnimation")
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
