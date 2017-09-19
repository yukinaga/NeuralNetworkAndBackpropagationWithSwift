//
//  ViewController.swift
//  NeuralNetwork
//
//  Created by Yukinaga2 on 2017/08/21.
//  Copyright © 2017年 Yukinaga Azuma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let pointSize:CGFloat = 10 //Size of each point
    var points = [Worm]() //Worms to show output

    //Canvas size
    let canvasLeft:CGFloat = 100
    let canvasTop:CGFloat = 40
    var canvasWidth:CGFloat!
    var canvasHeight:CGFloat!

    //Neural network
    var neuralNetwork:NeuralNetwork!
    let layers = [1, 10, 5, 1]
    
    var displayLink:CADisplayLink!
    
    let pointsNum = 101 //Number of points for one data set
    var inputs:[Float] = []
    var answears:[Float] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasWidth = self.view.frame.size.width - 2 * canvasLeft
        canvasHeight = self.view.frame.size.height - 2 * canvasTop
        
        putPoints(pointsNum: pointsNum)
        
        makeShuffledSignData(pointsNum: pointsNum)
        
        neuralNetwork = NeuralNetwork(layers: layers)
        
        displayLink = CADisplayLink(target: self, selector: #selector(ViewController.updateWithCPU))
        displayLink.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
        displayLink.preferredFramesPerSecond = 30
    }
    
    func updateWithCPU()
    {
        var errSum:Float = 0 //Sum of squared error
        for i in 0..<pointsNum {
            neuralNetwork.forward(data: [inputs[i]])
            neuralNetwork.backward(answers: [answears[i]])
            
            errSum += (answears[i] - neuralNetwork.neurons.last![0]) * (answears[i] - neuralNetwork.neurons.last![0])
            setPoints(point: points[i], nX: inputs[i], nY: neuralNetwork.neurons.last![0])
        }
        print(errSum / Float(pointsNum))
    }
    
    func putPoints(pointsNum: Int){
        
        let hInterval = canvasWidth / CGFloat(pointsNum - 1)
        
        for i in 0..<pointsNum{
            let point = Worm()
            point.center = CGPoint(x: canvasLeft + hInterval * CGFloat(i), y: canvasTop + canvasHeight/2)
            points.append(point)
            self.view.addSubview(point)
        }
    }
    
    func setPoints(point:Worm, nX: Float, nY: Float){
        point.move(x: canvasLeft + canvasWidth * CGFloat(nX), y: canvasTop + canvasHeight * (1-CGFloat(nY)))
    }
    
    func makeSinData(pointsNum: Int) -> [[Float]]{
        var sinData = [[Float]]()
        let hInterval = 2 * Double.pi / Double(pointsNum - 1)
        for i in 0..<pointsNum {
            let x = -Double.pi + hInterval * Double(i)
            let y = sin(x)
            sinData.append([Float((x/Double.pi + 1)/2), Float((y + 1)/2)])
        }
        return sinData
    }
    
    func makeShuffledSignData(pointsNum: Int) {
        let sinData = makeSinData(pointsNum:pointsNum).shuffled()
        for sd in sinData {
            inputs.append(sd[0])
            answears.append(sd[1])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension Array {
    
    func shuffled() -> [Element] {
        var results = [Element]()
        var indexes = (0 ..< count).map { $0 }
        while indexes.count > 0 {
            let indexOfIndexes = Int(arc4random_uniform(UInt32(indexes.count)))
            let index = indexes[indexOfIndexes]
            results.append(self[index])
            indexes.remove(at: indexOfIndexes)
        }
        return results
    }
    
}
