//
//  ViewController.swift
//  MLPhotos
//
//  Created by Royce Bradley on 2020-01-08.
//  Copyright © 2020 Royce Bradley. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet var resultLabel: UILabel!
    
    //let model = GoogLeNetPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // WRONG
        //let image = UIImage(named: "puppy.jpg")
        //model.prediction(input: image)
        
        let path = Bundle.main.path(forResource: "puppy", ofType: "jpg")
        let imageURL = NSURL.fileURL(withPath: path!)
        
        let ModelFile = Resnet50()
        let model =  try! VNCoreMLModel(for: ModelFile.model)
        let handler = VNImageRequestHandler(url: imageURL)
        let request = VNCoreMLRequest(model: model, completionHandler: myResultsMethod)
        
       try! handler.perform([request])
        
    }
    
    func myResultsMethod(request: VNRequest, error: Error?){
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("Could not get results from ML Vision request")
        }
        
        var bestPrediction = " "
        var bestConfidence: VNConfidence = 0
        
        for classification in results {
            if(classification.confidence > bestConfidence){
                bestConfidence = classification.confidence
                bestPrediction = classification.identifier
            }
        }
    
        
    print("Predicted: \(bestPrediction) with confidence of \(bestConfidence) out of 1")
    self.resultLabel.text = bestPrediction
    
    }
    
    


}

