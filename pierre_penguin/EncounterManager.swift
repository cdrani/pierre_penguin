//
//  EncounterManager.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-25.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class EncounterManager {
    // Encounter file names:
    let encounterNames: [String] = [
        "EncounterA",
        "EncounterB",
        "EncounterC"
    ]
    
    // Each encounter is an SKNode:
    var encounters: [SKNode] = []
    
    var currentEncounterIndex:Int?
    var previousEncounterIndex:Int?
    
    init() {
        // Loop through each encounter scene:
        for encounterFileName in encounterNames {
            // new node for encounter:
            let encounterNode = SKNode()
            
            // Load scene into SKScene instance:
            if let encounterScene = SKScene(fileNamed: encounterFileName) {
                // Loop through each child node in SKScene:
                for child in encounterScene.children {
                    // create copy of scene's child node to add to encounter node:
                    let copyOfNode = type(of: child).init()
                    // Save scene node's position:
                    copyOfNode.position = child.position
                    // Save scene node's name:
                    copyOfNode.name = child.name
                    // add to encounter node:
                    encounterNode.addChild(copyOfNode)
                    
                    // Save initial sprite positions for this encounter:
                    saveSpritePositions(node: encounterNode)
                    
                    // Turn golden coins gold:
                    encounterNode.enumerateChildNodes(withName: "gold") {
                        (node: SKNode, stop: UnsafeMutablePointer) in
                        (node as? Coin)?.turnToGold()
                    }
                }
            }
            
            // Add populated encounter node to array:
            encounters.append(encounterNode)
        }
    }
    
    // Append all encounter nodes to world node from GameScene:
    func addEncountersToScene(gameScene: SKNode) {
        var encounterPosY = 100
        for encounterNode in encounters {
            // Spawn encounters behind the action, with increasing height
            // to avoid collision:
            encounterNode.position = CGPoint(x: -2000, y: encounterPosY)
            gameScene.addChild(encounterNode)
            // Double Y pos for next encounter:
            encounterPosY *= 2
        }
    }
    
    // Store initial positions of children of a node:
    func saveSpritePositions(node: SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                let initialPositionValue = NSValue.init(cgPoint: sprite.position)
                spriteNode.userData = ["initialPosition": initialPositionValue]
                // Save positions for children of this node:
                saveSpritePositions(node: spriteNode)
            }
        }
    }
    
    // Reset all children nodes to original position:
    func resetSpritePositions(node: SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                // Remove any linear or angular velocity:
                spriteNode.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                spriteNode.physicsBody?.angularVelocity = 0
                // Reset rotation of the sprite:
                spriteNode.zRotation = 0
                if let initialPositionalValue = spriteNode.userData?.value(forKey: "initialPosition") as? NSValue {
                    // Reset position of sprite:
                    spriteNode.position = initialPositionalValue.cgPointValue
                }
                
                // Reset positions on this node's children:
                resetSpritePositions(node: spriteNode)
            }
        }
    }
    
    func placeNextEncounter(currentXPos:CGFloat) {
        // Count encounter in random ready type (UIInt32):
        let encounterCount = UInt32(encounters.count)
        
        // Require min. 3 encounters for game
        if encounterCount < 3 { return }
        
        // Select encounter currently not on screen:
        var nextEncounterIndex:Int?
        var trulyNew:Bool?
        
        // current and previous encounter can potentionally be on screen:
        while trulyNew == false || trulyNew == nil {
            // Pick random encounter to set next:
            nextEncounterIndex = Int(arc4random_uniform(encounterCount))
            // Assert it's a new encounter:
            trulyNew = true
            // Test if it is the current encounter:
            if let currentIndex = currentEncounterIndex {
                if (nextEncounterIndex == currentIndex) {
                    trulyNew = false
                }
            }
            
            // Test if it is the directly previous encounter:
            if let previousIndex = previousEncounterIndex {
                if (nextEncounterIndex == previousIndex) {
                    trulyNew = false
                }
            }
        }
        
        // Keep track of current encounter:
        previousEncounterIndex = currentEncounterIndex
        currentEncounterIndex = nextEncounterIndex
        
        // Reset the new encounter and position it ahead of the player:
        let encounter = encounters[currentEncounterIndex!]
        encounter.position = CGPoint(x: currentXPos + 1000, y: 300)
        resetSpritePositions(node: encounter)
    }
}
