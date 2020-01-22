//
//  GameMenu.swift
//  multipeer_not
//
//  Created by Miguel Angel Sicart on 20/01/2020.
//  Copyright © 2020 playable_systems. All rights reserved.
//

//TOOLBAR: https://www.hackingwithswift.com/example-code/uikit/how-to-show-and-hide-a-toolbar-inside-a-uinavigationcontroller


import UIKit
import MultipeerConnectivity
import CoreML
import Vision
import AVFoundation

class GameMenu: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate
{
    //MARK: - MULTIPEER UI VARIABLES
    var hostButton: UIButton!
    var joinButton: UIButton!
    
    //MARK: - MULTIPEER VARIABLES
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    //MARK: - GAME UI VARIABLES
    var camera: UIBarButtonItem!
    var reset: UIBarButtonItem!
    var library: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

       //MARK: - MULTIPEER INTERFACE
        hostButton = UIButton(frame: CGRect(x: (view.frame.midX) - 50, y: (view.frame.midY) - 50, width: 100, height: 50))
        hostButton.backgroundColor = .darkGray
        hostButton.layer.cornerRadius = 14
        hostButton.setTitle("Host Game", for: .normal)
        hostButton.addTarget(self, action: #selector(hostGame), for: .touchUpInside)
        self.view.addSubview(hostButton)
        
        joinButton = UIButton(frame: CGRect(x: (view.frame.midX) - 50, y: (view.frame.midY) + 50, width: 100, height: 50))
        joinButton.backgroundColor = .darkGray
        joinButton.layer.cornerRadius = 14
        joinButton.setTitle("Join Game", for: .normal)
        joinButton.addTarget(self, action: #selector(joinGame), for: .touchUpInside)
        self.view.addSubview(joinButton)
        
        //MARK: - MULTIPEER
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        //MARK: - GAME INTERFACE
        navigationController?.setToolbarHidden(true, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
        reset = UIBarButtonItem(title: "RESET", style: .plain, target: self, action: #selector(resetGame))
        library = UIBarButtonItem(title: "LIBRARY", style: .plain, target: self, action: #selector(openPhotoLibrary))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, library, spacer, spacer, camera, spacer, spacer, reset, spacer]
        
    }
    

    // MARK: - BUTTON ACTIONS
    @objc func hostGame(sender: UIButton)
    {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "PN-game", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
        
        hostButton.isHidden = true
        joinButton.isHidden = true
        
        startGame()
    }
    
    
    @objc func joinGame(sender: UIButton)
    {
        let mcBrowser = MCBrowserViewController(serviceType: "PN-game", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
        hostButton.isHidden = true
        joinButton.isHidden = true
    }
    
    //MARK: - MULTIPEER FUNCTIONS
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        print("browser finished")
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        hostButton.isHidden = false
        joinButton.isHidden = false
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        @unknown default:
            print("Fatal Error")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    
    //MARK: - GAME FUNCTIONS

    func startGame()
    {
        print("game started")
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    @objc func takePicture()
    {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func openPhotoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    @objc func resetGame()
    {
        
    }
    
    //MARK: - IMAGE PICKER CONTROLLER
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        
        var selectedImagefromPicker: UIImage?
       
        if let editedImage = info[.editedImage] as? UIImage
        {
            selectedImagefromPicker = editedImage
        }
        else if let originalImage = info[.originalImage] as? UIImage
        {
            selectedImagefromPicker = originalImage
        }
        
        if let selectedImage = selectedImagefromPicker
        {
            print(selectedImage)
//            outletView.image = selectedImage
//            guard let transformedImage = CIImage(image: selectedImage) else { return }
//            artificialIntelligence(image: transformedImage)
        }
        print(selectedImagefromPicker!.size)
        
        dismiss(animated: true, completion: nil)
    }
}
