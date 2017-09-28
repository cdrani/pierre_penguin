//
//  ParticlePool.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-27.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class ParticlePool {
    var cratePool:[SKEmitterNode] = []
    var heartPool:[SKEmitterNode] = []
    var crateIndex = 0
    var heartIndex = 0
    // Store reference to gamescene
    var gameScene = SKScene()
    
    init() {
        // crate explosion emitter nodes:
        for i in 1...5 {
            // Create crate emitter node:
            let crate = SKEmitterNode(fileNamed: "CrateExplosion")!
            crate.position = CGPoint(x: -2000, y: -2000)
            crate.zPosition = CGFloat(45 - i)
            crate.name = "crate" + String(i)
            // add emitter to cratePool array:
            cratePool.append(crate)
        }
        
        // heart emitter nodes:
        for i in 1...1 {
            let heart = SKEmitterNode(fileNamed: "HeartExplosion")!
            heart.position = CGPoint(x: -2000, y: -2000)
            heart.zPosition = CGFloat(45 - i)
            heart.name = "heart" + String(i)
            // add emitter to heartPool array:
            heartPool.append(heart)
        }
    }
    
    // Add emitters as children
    func addEmittersToScene(scene:GameScene) {
        self.gameScene = scene
        // add crate emitter to scene
        for i in 0..<cratePool.count {
            self.gameScene.addChild(cratePool[i])
        }
        // add heart emitter to scene
        for i in 0..<heartPool.count {
            self.gameScene.addChild(heartPool[i])
        }
    }
    
    // Reposition next pooled in position:
    func placeEmitter(node:SKNode, emitterType:String) {
        var emitter:SKEmitterNode
        switch emitterType {
        case "crate":
            emitter = cratePool[crateIndex]
            crateIndex += 1
            if crateIndex >= cratePool.count {
                crateIndex = 0
            }
        case "heart":
            emitter = heartPool[heartIndex]
            heartIndex += 1
            if heartIndex >= heartPool.count {
                heartIndex = 0
            }
        default:
            return
        }
        
        // Find node's position relativet to GameScene:
        var absolutePosition = node.position
        if node.parent != gameScene {
            absolutePosition = gameScene.convert(node.position, from: node.parent!)
        }
        
        // Position emitter on top of node:
        emitter.position = absolutePosition
        // Restart emitter animation:
        emitter.resetSimulation()
    }
}
