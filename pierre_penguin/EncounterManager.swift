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
}
