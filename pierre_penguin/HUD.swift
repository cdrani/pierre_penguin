//
//  HUD.swift
//  pierre_penguin
//
//  Created by cdrainxv on 2017-09-26.
//  Copyright © 2017 cdrainxv. All rights reserved.
//

import Foundation
import SpriteKit

class HUD: SKNode {
    var textureAtlas = SKTextureAtlas(named: "HUD")
    var coinAtlas = SKTextureAtlas(named: "Environment")
    // Keep track of hearts
    var heartNodes:[SKSpriteNode] = []
    // Print the coin score:
    let cointCountText = SKLabelNode(text: "000000")
}
