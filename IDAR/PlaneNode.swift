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
    let width : CGFloat
    let height : CGFloat
    let cornerRadius : CGFloat
  
    init(color : UIColor, position : SCNVector3, width : CGFloat, height : CGFloat, cornerRadius : CGFloat) {
        self.color = color
        self.position = position
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    func CreatePlaneNode()-> SCNNode{
        let planeNode = SCNNode()
        let plane = SCNPlane(width: width , height: height)
        plane.cornerRadius = cornerRadius
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
