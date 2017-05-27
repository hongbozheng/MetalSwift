//
//  ViewController.swift
//  MetalSwift
//
//  Created by Danny on 5/27/17.
//  Copyright © 2017 Danny. All rights reserved.
//

//https://www.raywenderlich.com/146414/metal-tutorial-swift-3-part-1-getting-started

/**
 In this tutorial, you’ll get some hands-on experience using Metal and Swift to create a bare-bones app: drawing a simple triangle. In the process, you’ll learn about some of the most important classes in Metal, such as devices, command queues, and more.
 */

import UIKit
import Metal

class ViewController: UIViewController {
    var device:MTLDevice!
    var metalLayer: CAMetalLayer!
    let vertexData:[Float] = [0.0,1.0,0.0,-1.0,-1.0,0.0,1.0,-1.0,0.0]
    var vertexBuffer:MTLBuffer!
    var pipelineState : MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var timer:CADisplayLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        device = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])
        
        let defaultLibrary = device.newDefaultLibrary()
        let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = device.makeCommandQueue()
        
        timer = CADisplayLink(target: self, selector: #selector(ViewController.gameloop))
        timer.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    }
    
    func render(){
        guard let drawable = metalLayer?.nextDrawable()  else {
            return
        }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255, blue: 5.0/255.0, alpha: 1.0)
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3,instanceCount:1)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }
    func gameloop() {
        autoreleasepool{
            self.render()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}



}
