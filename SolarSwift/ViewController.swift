//
//  ViewController.swift
//  SolarSystemTesting
//
//  Created by Austin Bennett on 2/18/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    //radius in miles
    let sunRealSize = 432376.0
    let mercuryRealSize = 1516.0
    let venusRealSize = 3760.0
    let earthRealSize = 3959.0
    let marsRealSize = 2106.0
    let jupiterRealSize = 43441.0
    let saturnRealSize = 36184.0
    let uranusRealSize = 15759.0
    let neptuneRealSize = 15299.0
    let scalar:Float = 0.25
    /* 0.25 / 432376.0 or scalar/sunRealSize for real size comparisons, but you can't see the inner planets given the scaled sizes with the sun */
    //let scale = 0.25/432376.0 //scalar / sunRealSize
    let scale = 2.5/432376.0
    
    //All of these are to scale
    /*let mercuryOrbit = ((29.0 + 43.0) / 2.0) * 1000000 // average distance in miles
    let venusOrbit = 67000000.0
    let earthOrbit = 92960000.0
    let marsOrbit = 141600000.0
    let jupiterOrbit = 483600000.0
    let saturnOrbit = 886500000.0
    let uranusOrbit = 1783700000.0
    let neptuneOrbit = 2795200000.0
    let orbitScale = 25.0/2795200000.0 //scalar * 100 / earthOrbit*/
    let mercuryOrbit = 0.4 // average distance in miles
    let venusOrbit = 0.7
    let earthOrbit = 1.0
    let marsOrbit = 1.5
    let jupiterOrbit = 5.2
    let saturnOrbit = 9.5
    let uranusOrbit = 19.8
    let neptuneOrbit = 30.1
    let orbitScale = 1.0 //scalar * 100 / earthOrbit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let baseNode = SCNNode()
        
        let sun = createPlanet(radius: Float(sunRealSize * (0.25/432376.0)), image: "sun")
        sun.position = SCNVector3(x: 0, y: 0, z: 0)
        rotateObject(rotation: -0.3, planet: sun, duration: 1)
        
        baseNode.addChildNode(sun)
        baseNode.position = SCNVector3(x: 0, y:-0.5, z:-1)
        
        let scene = SCNScene()
        scene.background.contents = UIColor.black
        sceneView.scene = scene
        sceneView.scene.rootNode.addChildNode(baseNode)
        sceneView.allowsCameraControl = true
        
        let earthYear:Float = 365.25
        let orbitDuration:Float = 25.0
        
        let mercuryRotationSpeed:Float = (88 / 175.97) / orbitDuration
        let venusRotationSpeed:Float = -(225 / 243) / orbitDuration
        let earthRotationSpeed:Float = earthYear / orbitDuration
        let marsRotationSpeed:Float = 687 / orbitDuration
        let jupiterRotationSpeed:Float = (4333 / (24 / 10)) / orbitDuration
        let saturnRotationSpeed:Float = (10759 / (24 / 10.7)) / orbitDuration
        let uranusRotationSpeed:Float = (30687 / (24 / 17)) / orbitDuration
        let neptuneRotationSpeed:Float = (60190 / (24 / 16)) / orbitDuration
        
        //Mercury
        createNewPlanetAndOrbit(baseNode: baseNode, planetSize: Float(mercuryRealSize * scale), ringSize: scalar + Float(mercuryOrbit * orbitScale), name: "mercury", planetRotationSpeed: mercuryRotationSpeed, planetRotationDuration: 1.0, orbitSpeed: earthYear/87.97, orbitDuration: orbitDuration)
        //Venus
        createNewPlanetAndOrbit(baseNode: baseNode, planetSize: Float(venusRealSize * scale), ringSize: scalar + Float(venusOrbit * orbitScale), name: "venus", planetRotationSpeed: venusRotationSpeed, planetRotationDuration: 1.0, orbitSpeed: earthYear/225.0, orbitDuration: orbitDuration)
        //Earth
        createNewPlanetAndOrbit(baseNode: baseNode, planetSize: Float(earthRealSize * scale), ringSize: scalar + Float(earthOrbit * orbitScale), name: "earth", planetRotationSpeed: earthRotationSpeed, planetRotationDuration: 1.0, orbitSpeed: 1.0, orbitDuration: orbitDuration)
        //Mars
        createNewPlanetAndOrbit(baseNode: baseNode, planetSize: Float(marsRealSize * scale), ringSize: scalar + Float(marsOrbit * orbitScale), name: "mars", planetRotationSpeed: marsRotationSpeed, planetRotationDuration: 1.0, orbitSpeed: earthYear/686.97, orbitDuration: orbitDuration)
        //Jupiter
        createNewPlanetAndOrbit(baseNode: baseNode, planetSize: Float(jupiterRealSize * scale), ringSize: scalar + Float(jupiterOrbit * orbitScale), name: "jupiter", planetRotationSpeed: jupiterRotationSpeed, planetRotationDuration: earthYear/4332.59, orbitSpeed: 0.4, orbitDuration: orbitDuration)
        //Saturn
        createNewPlanetAndOrbit(baseNode: baseNode, planetSize: Float(saturnRealSize * scale), ringSize: scalar + Float(saturnOrbit * orbitScale), name: "saturn", planetRotationSpeed: saturnRotationSpeed, planetRotationDuration: 1.0, orbitSpeed: earthYear/10759.22, orbitDuration: orbitDuration)
        // this thing needs a wring
        
        //Uranus
        createNewPlanetAndOrbit(baseNode: baseNode, planetSize: Float(uranusRealSize * scale), ringSize: scalar + Float(uranusOrbit * orbitScale), name: "uranus", planetRotationSpeed: uranusRotationSpeed, planetRotationDuration: 1.0, orbitSpeed: earthYear/30688.5, orbitDuration: orbitDuration)
        //this thing also needs a wring
        
        //Neptune
        createNewPlanetAndOrbit(baseNode: baseNode, planetSize: Float(neptuneRealSize * scale), ringSize: scalar + Float(neptuneOrbit * orbitScale), name: "neptune", planetRotationSpeed: neptuneRotationSpeed, planetRotationDuration: 1.0, orbitSpeed: earthYear/60182, orbitDuration: orbitDuration)
    }
    
    func createNewPlanetAndOrbit(baseNode:SCNNode, planetSize:Float, ringSize:Float, name:String, planetRotationSpeed:Float, planetRotationDuration:Float, orbitSpeed:Float, orbitDuration:Float) {
        let orbitalPathRing = createRing(ringSize: ringSize, lineThickness: 0.0001)
        baseNode.addChildNode(orbitalPathRing)
        let planetRing = createRing(ringSize: ringSize, lineThickness: 0.0)
        let planet = createPlanet(radius: planetSize, image: name)
        planet.name = name
        planet.position = SCNVector3(ringSize, 0, 0)
        rotateObject(rotation: orbitSpeed, planet: planetRing, duration: orbitDuration)
        rotateObject(rotation: planetRotationSpeed, planet: planet, duration: planetRotationDuration)
        
        //Planet's ring, not planet's orbit ring
        //let shapePath = Path.circle(
        
        planetRing.addChildNode(planet)
        baseNode.addChildNode(planetRing)
    }
    
    func createNewPlanetWithRingAndOrbit(baseNode:SCNNode, planetSize:Float, ringSize:Float, name:String, planetRotationSpeed:Float, planetRotationDuration:Float, orbitSpeed:Float, orbitDuration:Float, ringOfPlanet:Float, ringOfPlanetThickness:Float) {
        let orbitalPathRing = createRing(ringSize: ringSize, lineThickness: 0.0001)
        baseNode.addChildNode(orbitalPathRing)
        let planetRing = createRing(ringSize: ringSize, lineThickness: 0.0)
        
        let planet = createPlanet(radius: planetSize, image: name)
        planet.name = name
        planet.position = SCNVector3(ringSize, 0, 0)
        rotateObject(rotation: orbitSpeed, planet: planetRing, duration: orbitDuration)
        rotateObject(rotation: planetRotationSpeed, planet: planet, duration: planetRotationDuration)
        planetRing.addChildNode(planet)
        baseNode.addChildNode(planetRing)
    }
    
    func createPlanet(radius: Float, image:String) -> SCNNode {
        let planet = SCNSphere(radius: CGFloat(radius))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: image)
        planet.materials = [material]
        
        let planetNode = SCNNode(geometry: planet)
        return planetNode
    }
    
    func createRing(ringSize: Float, lineThickness:Float) -> SCNNode {
        let ring = SCNTorus(ringRadius: CGFloat(ringSize), pipeRadius: CGFloat(lineThickness))
        let material = SCNMaterial()
        ring.materials = [material]
        let ringNode = SCNNode(geometry: ring)
        return ringNode
    }
    
    func rotateObject(rotation:Float, planet: SCNNode, duration:Float) {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(rotation), z: 0, duration: TimeInterval(duration))
        planet.runAction(SCNAction.repeatForever(rotation))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
