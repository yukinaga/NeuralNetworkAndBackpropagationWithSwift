//
//  NeuralNetwork.swift
//  NeuralNetwork
//
//  Created by Yukinaga2 on 2017/08/21.
//  Copyright © 2017年 Yukinaga Azuma. All rights reserved.
//

import UIKit

class NeuralNetwork: NSObject {
    
    var neurons = [[Float]]()
    var weights = [[[Float]]]()
    
    init(layers: [Int]) {
        //Initial setting of neurons
        for i in 0..<layers.count {
            neurons.append([])
            for _ in 0..<layers[i] {
                neurons[i].append(0)
            }
        }
        //Initial settings of weight
        for i in 0..<layers.count - 1 {
            weights.append([])
            for j in 0...layers[i] { //Including bias
                weights[i].append([])
                for _ in 0..<layers[i+1] {
                    let rand = (Float(arc4random_uniform(2001)) - Float(1000) ) / Float(1000) * 1.0
                    weights[i][j].append(rand)
                }
            }
        }
    }
    
    func forward(data:[Float]){
        //Reset neuron values
        for i in 0..<neurons.count {
            for j in 0..<neurons[i].count {
                neurons[i][j] = 0
            }
        }
        //Set inputs at the initial layer
        for i in 0..<neurons[0].count {
            neurons[0][i] = data[i]
        }
        //Neural network
        for i in 0..<weights.count {
            for j in 0..<weights[i].count { //Including bias
                for k in 0..<weights[i][j].count {
                    let neuron = j == weights[i].count-1 ? 1 : neurons[i][j] //Bias: 1, Others: neuron value
                    neurons[i+1][k] += neuron * weights[i][j][k]
                }
            }
            for j in 0..<neurons[i+1].count {
                neurons[i+1][j] = sigmoid(x: neurons[i+1][j])
            }
        }
    }
    
    func backward(answers:[Float]) {
        
        if neurons.count <= 1 {
            print("Too small number of layers.")
            return
        }
        
        let coef:Float = 0.3 //Learning coefficient
        
        //Error to previous layer
        let bottomWeights = weights.last!
        let bottomNeurons = neurons.last!
        var deltas = [Float](repeating: 0.0, count: bottomNeurons.count)
        for i in 0..<bottomNeurons.count {
            deltas[i] = (answers[i] - bottomNeurons[i]) * bottomNeurons[i] * (1.0 - bottomNeurons[i])
            for j in 0..<bottomWeights.count {
                let upperNeuron = j == bottomWeights.count-1 ? 1 : neurons[neurons.count-2][j]
                weights[weights.count-1][j][i] += deltas[i] * upperNeuron * coef
            }
        }
        
        //Backpropagation
        var lastWeights = bottomWeights
        for i in (0..<weights.count-1).reversed() {
            let updatingWeights = weights[i]
            let lowerWeights = weights[i+1]
            let lowerLayerNeurons = neurons[i+1]
            let upperLayerNeurons = neurons[i]
            var newDeltas = [Float](repeating: 0.0, count: lowerLayerNeurons.count)
            for j in 0..<lowerWeights.count-1 { //Excludiong bias
                for k in 0..<lowerWeights[j].count {
                    newDeltas[j] += deltas[k] * lastWeights[j][k] * lowerLayerNeurons[j] * (1 - lowerLayerNeurons[j])
                }
                for k in 0..<weights[i].count { //Including bias
                    let upperNeuron = k == weights[i].count-1 ? 1 : upperLayerNeurons[k]
                    weights[i][k][j] += upperNeuron * newDeltas[j] * coef
                }
            }
            lastWeights = updatingWeights
            deltas = newDeltas
        }
    }
    
    //Sigmoid function
    func sigmoid(x:Float) -> Float{
        return 1.0 / (1.0 + exp(-x))
    }
    
    //Derivative of sigmoid function
    func sigmoidDif(x:Float) -> Float{
        return sigmoid(x: x) * (1 - sigmoid(x: x))
    }
}
