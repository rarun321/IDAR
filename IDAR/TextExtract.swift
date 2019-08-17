//
//  TextExtract.swift
//  IDAR
//
//  Created by Rithvik Arun on 8/1/19.
//  Copyright © 2019 Projects. All rights reserved.
//

import Foundation
import Vision
import UIKit

class TextExtract{
    
    var studentName : String
    var studentId : String
    var type :String
    
    init(image : UIImage) {
        studentName = ""
        studentId = ""
        type = ""
        //ExtractText(image: image)
    }
    
//    func ExtractText(image : UIImage){
//        guard let image = CIImage(image: image) else{return}
//        let requestHandler = VNImageRequestHandler(ciImage: image, options: [:])
//        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
//        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
//        request.revision = VNRecognizeTextRequestRevision1
//        try? requestHandler.perform([request])
//    }
//
//    func recognizeTextHandler(request: VNRequest, error: Error?){
//        guard let results = request.results as? [VNRecognizedTextObservation] else{return}
//        for result in results{
//            guard let phrase = result.topCandidates(1).first else{
//                continue
//            }
//            print(phrase.string)
//        }
//        studentName = results[0].topCandidates(1).first!.string
//        studentId = results[1].topCandidates(1).first!.string
//        type = results[2].topCandidates(1).first!.string
//    }
}
