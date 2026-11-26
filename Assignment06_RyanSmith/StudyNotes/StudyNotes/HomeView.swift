//
// HomeView.swift : StudyNotes
//
// Copyright © 2026 Auburn University.
// All Rights Reserved.


import SwiftUI
import PhotosUI

struct HomeView: View {
    @StateObject private var viewModel = JournalViewModel()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var noteToDelete: JournalEntry?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Turn photos of class notes into organized study material.")
                        .foregroundStyle(.secondary)
                }
                if !viewModel.storageAvailable {
                    Section("Saved notes unavailable") {
                        Text("Load your saved notes before adding or deleting notes.")
                        Button("Try Loading Again") { viewModel.loadEntries() }
                    }
                }
                Section("New Study Note") {
                    TextField("Title, e.g. Binary Search", text: $viewModel.draftTitle)
                    Picker("Course", selection: $viewModel.draftCourse) {
                        ForEach(CourseCategory.allCases) { course in
                            Text(course.rawValue).tag(course)
                        }
                    }
                    Text("Note text — type below or scan an image")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    TextEditor(text: $viewModel.draftText)
                        .frame(minHeight: 150)
                        .accessibilityLabel("Note text")
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Label("Scan Notes from Photo", systemImage: "text.viewfinder")
                    }
                    Text("Scanning adds text to your draft. Review and correct it before saving.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if viewModel.isScanning {
                        ProgressView("Reading text…")
                    }
                    Button { viewModel.addEntry() } label: {
                        Label("Save Note", systemImage: "square.and.arrow.down")
                    }
                }
                .disabled(viewModel.isScanning || !viewModel.storageAvailable)

                Section("Saved Notes") {
                    Picker("Filter by Course", selection: $viewModel.selectedCourse) {
                        Text("All Courses").tag(Optional<CourseCategory>.none)
                        ForEach(CourseCategory.allCases) { course in
                            Text(course.rawValue).tag(Optional(course))
                        }
                    }
                    Text("Showing \(viewModel.filteredEntries.count) of \(viewModel.entries.count) notes")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if viewModel.isLoading {
                        ProgressView("Loading notes…")
                    } else if !viewModel.storageAvailable {
                        Text("Notes could not be loaded. Use Try Loading Again above.")
                    } else if viewModel.entries.isEmpty {
                        ContentUnavailableView("No Study Notes Yet",
                            systemImage: "note.text",
                            description: Text("Add a title, choose a course, and type or scan your first note."))
                    } else if viewModel.filteredEntries.isEmpty {
                        ContentUnavailableView("No Notes for This Course",
                            systemImage: "folder",
                            description: Text("Choose All Courses to see your other notes."))
                    } else {
                        ForEach(viewModel.filteredEntries) { entry in
                            NavigationLink {
                                NoteDetailView(entry: entry)
                            } label: {
                                EntryCardView(entry: entry)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    noteToDelete = entry
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("StudyNotes")
            .task { viewModel.loadEntries() }
            .onChange(of: selectedPhotoItem) { _, item in
                guard let item else { return }
                Task {
                    await viewModel.scanPhoto(item)
                    selectedPhotoItem = nil
                }
            }
            .alert("StudyNotes", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .confirmationDialog("Delete this note?", isPresented: Binding(
                get: { noteToDelete != nil },
                set: { if !$0 { noteToDelete = nil } }
            ), titleVisibility: .visible) {
                Button("Delete Note", role: .destructive) {
                    if let entry = noteToDelete { viewModel.deleteEntry(entry) }
                    noteToDelete = nil
                }
                Button("Cancel", role: .cancel) { noteToDelete = nil }
            } message: {
                Text(noteToDelete?.title ?? "")
            }
        }
    }
}

#Preview { HomeView() }
