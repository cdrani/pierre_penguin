//
//  Ground.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-24.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

// Ground --> inherit from SKSpriteNode, adheres to GameSprite Protocol
class Ground: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var initialSize: CGSize = .zero
    
    // Tile the ground texture across the width of ground node
    func createChildren() {
        // anchor point just above the bottom of screen
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        // load the ground texture from atlas:
        let texture = textureAtlas.textureNamed("ground")
        
        var tileCount:CGFloat = 0
        // tiles are 35 wide, 300 tall
        let tileSize = CGSize(width: 35, height: 300)
        
        // build nodes to cover Ground width
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            // Position child noded by upper left corner
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            // Add child texture to ground node:
            self.addChild(tileNode)
            
            tileCount += 1
        }
        
        // Draw edge physics body along top of ground node
        // NOTE: physics body positions are relative to their nodes
        let pointTopLeft = CGPoint(x: 0, y: 0)
        let pointTopRight = CGPoint(x: size.width, y: 0)
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
    }
    
    func onTap() {
        
    }
}
