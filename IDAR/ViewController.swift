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
        
        guard let container = sceneView.scene.rootNode.childNode(withName: "container", recursively: false) else{return}
        container.removeFromParentNode()
        
        let colorArray = [UIColor.blue, UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.gray, UIColor.lightGray, UIColor.white, UIColor.magenta, UIColor.cyan, UIColor.brown]
        
        for course in courses{
            let plane = PlaneNode(color: colorArray.randomElement()!, position: SCNVector3(0,0,0))
            let planeNode = plane.CreatePlaneNode()
            planeNode.addChildNode(TextNode(text: course.name!, position: SCNVector3(0.35,1.7,0) , font: UIFont.init(name: "Futura", size: 14)!).CreatetextNode())
            planeNode.addChildNode(TextNode(text: course.enrollments![0].computed_current_grade!, position: SCNVector3(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##z: CGFloat##CGFloat#>), font: <#T##UIFont#>))
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
}

