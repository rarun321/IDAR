//
//  PlaneNode.swift
//  IDAR
//
//  Created by Rithvik Arun on 8/16/19.
//  Copyright © 2019 Projects. All rights reserved.
//

import Foundation
import ARKit

class PlaneNode{
    let color : UIColor
    let position : SCNVector3
  
    init(color : UIColor, position : SCNVector3) {
        self.color = color
        self.position = position
    }
    
    func CreatePlaneNode()-> SCNNode{
        let planeNode = SCNNode()
        let plane = SCNPlane(width: 2 , height: 3.6)
        plane.cornerRadius = 0.2
        let material = SCNMaterial()
        material.diffuse.contents = color
        plane.materials = [material]
        planeNode.geometry = plane
        planeNode.eulerAngles = SCNVector3(-89.5,0,0)
        planeNode.scale = SCNVector3(1,1,1)
        planeNode.position = position
        return planeNode
    }
}
