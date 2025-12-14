//
//  DocumentCameraView.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/13/25.
//

import Foundation
import VisionKit
import SwiftUI
import UIKit

struct DocumentCameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var images: [UIImage]
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = context.coordinator
        
        return documentCameraViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scanResult: $images)
    }
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        @Binding var scanResult: [UIImage]
        
        init(scanResult: Binding<[UIImage]>) {
            _scanResult = scanResult
        }
        
        /// Tells the delegate that the user successfully saved a scanned document from the document camera.
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true, completion: nil)
            scanResult = (0..<scan.pageCount).compactMap { scan.imageOfPage(at: $0) }
        }
        
        // Tells the delegate that the user canceled out of the document scanner camera.
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true, completion: nil)
        }
        
        /// Tells the delegate that document scanning failed while the camera view controller was active.
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document scanner error: \(error.localizedDescription)")
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
