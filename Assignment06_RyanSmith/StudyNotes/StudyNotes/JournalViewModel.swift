
import Foundation
import SwiftUI
import PhotosUI
import Combine
import UIKit

@MainActor
final class JournalViewModel: ObservableObject {
    @Published private(set) var entries: [JournalEntry] = []
    @Published var draftTitle = ""
    @Published var draftCourse: CourseCategory = .general
    @Published var draftText = ""
    @Published var selectedCourse: CourseCategory?
    @Published private(set) var isLoading = false
    @Published private(set) var isScanning = false
    @Published private(set) var storageAvailable = false
    @Published var errorMessage: String?

    private let storage = JournalStorage()
    private let textRecognitionService = TextRecognitionService()

    var filteredEntries: [JournalEntry] {
        guard let selectedCourse else { return entries }
        return entries.filter { $0.course == selectedCourse }
    }

    func loadEntries() {
        isLoading = true
        defer { isLoading = false }
        do {
            entries = try storage.loadEntries()
            storageAvailable = true
        } catch {
            // Prevent new writes from replacing data that failed to decode.
            storageAvailable = false
            errorMessage = "Saved notes could not be loaded. Your stored data has not been replaced. Try loading again."
        }
    }

    func addEntry() {
        guard storageAvailable, !isScanning else { return }
        let title = draftTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let text = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty, !text.isEmpty else {
            errorMessage = "Enter a title and write or scan some note text before saving."
            return
        }
        let entry = JournalEntry(title: title, course: draftCourse, text: text)
        let updated = [entry] + entries
        do {
            try storage.saveEntries(updated)
            entries = updated
            draftTitle = ""
            draftText = ""
            selectedCourse = nil
        } catch {
            errorMessage = "The note could not be saved. Your draft is still here."
        }
    }

    func deleteEntry(_ entry: JournalEntry) {
        guard storageAvailable else { return }
        let updated = entries.filter { $0.id != entry.id }
        do {
            try storage.saveEntries(updated)
            entries = updated
        } catch {
            errorMessage = "The note could not be deleted. Please try again."
        }
    }

    func scanPhoto(_ item: PhotosPickerItem) async {
        guard !isScanning else { return }
        // Busy state includes image loading, so saving cannot race the scan.
        isScanning = true
        errorMessage = nil
        defer { isScanning = false }
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                errorMessage = "The selected image could not be opened. Please choose another image."
                return
            }
            let text = try await textRecognitionService.recognizeText(from: image)
            guard !text.isEmpty else {
                errorMessage = "No text was found. Try a clearer image with readable notes."
                return
            }
            // Append scans so existing typed notes are preserved.
            if draftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                draftText = text
            } else {
                draftText += "\n\n" + text
            }
        } catch {
            errorMessage = "Text recognition failed. Please try another image."
        }
    }
}
