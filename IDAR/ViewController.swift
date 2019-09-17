//
//  ViewController.swift
//  IDAR
//
//  Created by Rithvik Arun on 8/1/19.
//  Copyright © 2019 Projects. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreGraphics


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var courses = [CourseInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/Scene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        self.GetAPIResponseForGrades()
        self.GetAPIResponseForTODO()
        
        //self.AddCGRectangle()
    }
    
    //Sets configuartion for tracking
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        guard let trackingImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {return}
        configuration.trackingImages = trackingImage
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //Renders the augmented platform
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("image found")
        
        guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else{return}
        container.removeFromParentNode()
        
        let colorArray = [UIColor.blue, UIColor.red, UIColor.orange, UIColor.green, UIColor.gray, UIColor.magenta, UIColor.cyan, UIColor.brown]
        
        for course in courses{
            let plane = PlaneNode(color: colorArray.randomElement()!, position: SCNVector3(0,0,0))
            let planeNode = plane.CreatePlaneNode()
            planeNode.addChildNode(TextNode(text: course.name!, position: SCNVector3(0.35,1.7,0) , font: UIFont(name: "Futura", size: 14)!).CreatetextNode())
            var grade = course.enrollments![0].computed_current_grade
            if grade == nil {
                grade = "A+"
            }
            planeNode.addChildNode(TextNode(text: grade!, position: SCNVector3(-1, -0.288, 0), font: UIFont(name: "Marker Felt", size: 49)!).CreatetextNode())
            var percentage = course.enrollments![0].computed_current_score
            if percentage == nil {
                percentage = 100.0
            }
            planeNode.addChildNode(TextNode(text: String(percentage!), position: SCNVector3(-0.812, 1.629, 0), font: UIFont(name: "Marker Felt", size: 21)!).CreatetextNode())
            container.addChildNode(planeNode)
        }
        RunPostitoningAlgorithmForPlanes(array: container.childNodes)
        node.addChildNode(container)
    }
    
    // Positions planes 2x2 grid
    func RunPostitoningAlgorithmForPlanes(array : [SCNNode]){
        let baseX = -2.0;
        let baseY = -1.5;
        let baseZ = 7.5;
        
        var position = SCNVector3(0,0,0)
        var subjectCount = 0
        var count = 1
        var xHolder = 0.0
        
        for node in array {
            if subjectCount % 2 == 0{
              position = SCNVector3(baseX + -(Double(count - 1) * 2.5), baseY, baseZ)
              xHolder = baseX + -(Double(count-1) * 2.5)
              count += 1
         }
         else{
             position = SCNVector3(xHolder, baseY, baseZ + 4)
         }
            node.position = position
            subjectCount += 1
        }
    }
    
    //Changes text of node that is passed in
    func ChangeTextNode(node : SCNNode, text: String, container: SCNNode, type: String){
        node.removeFromParentNode()
         let nodeGeometry = node.geometry as! SCNText
        
        if type == "Course"{
            let newText = text.replacingOccurrences(of: "(2019 Spring)", with: "")
            let newTextArr = newText.split(separator: ":")
            nodeGeometry.string = newTextArr[0] + "\n" + newTextArr[1]
        }
        else{
            nodeGeometry.string = text
        }
      
       node.geometry = nodeGeometry
       container.addChildNode(node)
    }
    
    func GetAPIResponseForGrades(){
        let canvasAPIUrl = URL(string: "https://asu.instructure.com/api/v1/courses?include[]=total_scores&access_token=7236~Xu8jfB2SU7m1dXyfoJIsCWcUBQmeTxDXWxzzEJhlZIB69phVPse5v3oMQAockxCR")!
        let task = URLSession.shared.dataTask(with: canvasAPIUrl) {(data,response,error) in
            guard let dataFromAPI = data else {return}
            if error == nil{
              guard let resp = try? JSONDecoder().decode([CourseInfo].self, from: dataFromAPI) else{return}
                for var course in resp {
                    if course.name?.contains("(2019 Fall)") == true {
                       guard let formattedName = course.name?.components(separatedBy: ":") else {return}
                        course.name = formattedName[0]
                        self.courses.append(course)
                    }
                }
            }
            else{
                print("ERROR")
            }
        }
        task.resume()
    }
    
    func GetAPIResponseForTODO(){
        let canvasAPI = URL(string:"https://asu.instructure.com/api/v1/users/self/todo?include[]=total_scores&access_token=7236~Xu8jfB2SU7m1dXyfoJIsCWcUBQmeTxDXWxzzEJhlZIB69phVPse5v3oMQAockxCR")!
        let task = URLSession.shared.dataTask(with: canvasAPI) {(data,response,error) in
            guard let dataFromAPI = data else {return}
            if error == nil{
                 guard let json = try? JSONDecoder().decode([TODOInfo].self, from: dataFromAPI) else {return}
            }
            else{
                print("Error")
            }
        }
        task.resume();
    }
}

