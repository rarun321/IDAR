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
    
    var courses = [Element]()
    
    
    
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
        
        self.GetAPIResponse()
        
        //self.AddCGRectangle()
    }
    
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("image found")
        
        let planeNode = PlaneNode(color: UIColor.red, position: SCNVector3(0,0,0))
        let planeNode2 = PlaneNode(color: UIColor.blue, position: SCNVector3(0,0,0))
        let planeNode3 = PlaneNode(color: UIColor.green, position: SCNVector3(0,0,0))
        let planeNode4 = PlaneNode(color: UIColor.yellow, position: SCNVector3(0,0,0))
        let planeNode5 = PlaneNode(color: UIColor.orange, position: SCNVector3(0,0,0))
        let planeNode6 = PlaneNode(color: UIColor.black, position: SCNVector3(0,0,0))
        guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else{return}
        container.removeFromParentNode()
        container.addChildNode(planeNode.CreatePlaneNode())
        container.addChildNode(planeNode2.CreatePlaneNode())
        container.addChildNode(planeNode3.CreatePlaneNode())
        container.addChildNode(planeNode4.CreatePlaneNode())
        container.addChildNode(planeNode5.CreatePlaneNode())
        container.addChildNode(planeNode6.CreatePlaneNode())
        
        RunPostitoningAlgorithmForPlanes(array: container.childNodes)
       
        
        node.addChildNode(container)
        
        
//        var childCourseNodes = [SCNNode]()
//        var childGradeNodes = [SCNNode]()
//        
//        for child in container.childNodes {
//            if child.name == "subject1" || child.name == "subject2" || child.name == "subject3" || child.name == "subject4"{
//                childCourseNodes.append(child)
//            }
//        }
//        
//        for child in container.childNodes{
//            if child.name == "subject1Grade" || child.name == "subject2Grade" || child.name == "subject3Grade" || child.name == "subject4Grade" {
//                childGradeNodes.append(child)
//            }
//        }
//        
//        var countGrade = 0;
//
//
//
//       
       
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
//            let snapShot = self.CropSnapShot()
//            let extraction = TextExtract(image: snapShot)
//
//
//            guard let container = self.sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else {return}
//            guard let nameNode = container.childNode(withName: "name", recursively: false) else {return}
//            guard let studentIdNode = container.childNode(withName: "studentId", recursively: false) else {return}
//            guard let pitchFork = container.childNode(withName: "pitchFork", recursively: false) else {return}
//            guard let typeNode = container.childNode(withName: "type", recursively: false) else {return}
//            self.AddAction(node: pitchFork)
//
//            container.addChildNode(self.ChangeNodeText(node: nameNode, text: extraction.studentName))
//            container.addChildNode(self.ChangeNodeText(node: studentIdNode, text: extraction.studentId))
//            container.addChildNode(self.ChangeNodeText(node: typeNode, text: extraction.type))
//
//            node.addChildNode(container)
//            container.isHidden = false

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
    
    func AddAction(node : SCNNode){
        let action = SCNAction.repeat(SCNAction.rotate(by: 10, around: SCNVector3(1,0,0), duration: 5.0), count: 10)
        node.runAction(action)
    }
    
    func AddCGRectangle(){
        let rect = CGRect(x: 100, y:150, width: 200, height: 75)
        let myView = UIView(frame: rect)
        myView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.view.addSubview(myView)
    }
    
    func CropSnapShot() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 200, height: 75), false, 0);
        self.view.drawHierarchy(in: CGRect(x: -100, y: -150, width: view.bounds.size.width, height: view.bounds.size.height), afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    func GetAPIResponse(){
        let canvasAPIUrl = URL(string: "https://asu.instructure.com/api/v1/courses?include[]=total_scores&access_token=7236~Xu8jfB2SU7m1dXyfoJIsCWcUBQmeTxDXWxzzEJhlZIB69phVPse5v3oMQAockxCR")!
        let task = URLSession.shared.dataTask(with: canvasAPIUrl) {(data,response,error) in
        
            guard let dataFromAPI = data else {return}
            if error == nil{
              guard let resp = try? JSONDecoder().decode([Element].self, from: dataFromAPI) else{return}
              self.courses = resp
            }
            else{
                print("ERROR")
            }
        }
        task.resume()
    }
}

