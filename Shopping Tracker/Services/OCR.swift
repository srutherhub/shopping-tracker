//
//  OCR.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/13/25.
//

import Foundation
import Vision
import SwiftUI
import AVFoundation

func performOCR(on image: UIImage) {
    guard let cgImage = image.cgImage else { return }
    
    let request = VNRecognizeTextRequest { request, error in
        guard let observations = request.results as? [VNRecognizedTextObservation],
              error == nil else {
            print("OCR failed: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        let recognizedText = observations.compactMap {observation in
            observation.topCandidates(1).first?.string
        }.joined(separator:"\n")
    }
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true
    request.minimumTextHeight = 0.01
    
    let handler = VNImageRequestHandler(cgImage: cgImage, options:[:])
    DispatchQueue.global(qos:.userInitiated).async {
        try? handler.perform( [request] )
    }
}
