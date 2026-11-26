//
// TextRecognitionService.swift : StudyNotes
//
// Copyright © 2026 Auburn University.
// All Rights Reserved.


import Foundation
import Vision
import UIKit

final class TextRecognitionService {
    @MainActor
    func recognizeText(from image: UIImage) async throws -> String {
        // Drawing applies UIImage orientation before sending pixels to Vision.
        guard image.size.width > 0, image.size.height > 0 else {
            throw TextRecognitionError.invalidImage
        }
        let normalizedImage = UIGraphicsImageRenderer(size: image.size).image { _ in
            image.draw(in: CGRect(origin: .zero, size: image.size))
        }
        guard let imageData = normalizedImage.pngData() else {
            throw TextRecognitionError.invalidImage
        }
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let request = VNRecognizeTextRequest()
                    request.recognitionLevel = .accurate
                    request.usesLanguageCorrection = true
                    let handler = VNImageRequestHandler(data: imageData, options: [:])
                    try handler.perform([request])
                    let recognizedText = (request.results ?? [])
                        .compactMap { $0.topCandidates(1).first?.string }
                        .joined(separator: "\n")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    continuation.resume(returning: recognizedText)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

enum TextRecognitionError: Error {
    case invalidImage
}
