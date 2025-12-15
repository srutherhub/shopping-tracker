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

func performOCR(on image: UIImage) async -> String {
    guard let cgImage = image.cgImage else { return "" }
    
    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true
    request.minimumTextHeight = 0.01
    
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    
    do {
        try handler.perform([request])
        
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            return ""
        }
        
        let recognizedText = observations.compactMap { observation in
            observation.topCandidates(1).first?.string
        }.joined(separator: "\n")
        
        return recognizedText
    } catch {
        print("OCR failed: \(error.localizedDescription)")
        return ""
    }
}
