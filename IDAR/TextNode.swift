//
//  TextNode.swift
//  IDAR
//
//  Created by Rithvik Arun on 8/17/19.
//  Copyright © 2019 Projects. All rights reserved.
//

import Foundation
import ARKit

class TextNode{
    
let text : String
let position : SCNVector3
let font : UIFont
    
    init(text : String, position : SCNVector3, font: UIFont) {
        self.text = text
        self.position = position
        self.font = font
    }
    
    func CreatetextNode() -> SCNNode{
        let textNode = SCNNode()
        let textGeometry = SCNText(string: text, extrusionDepth: 0.2)
        let materials = SCNMaterial()
        materials.diffuse.contents = font
        
        textGeometry.materials = [materials]
        textNode.geometry = textGeometry
        textNode.position = position
        textNode.scale = SCNVector3(0.03, 0.03, 0.03)
        textNode.eulerAngles = SCNVector3(0,0,-89.53)
        return textNode
    }
}
