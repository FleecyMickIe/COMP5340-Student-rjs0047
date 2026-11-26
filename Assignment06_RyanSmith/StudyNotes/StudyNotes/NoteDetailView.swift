
import SwiftUI

struct NoteDetailView: View {
    let entry: JournalEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(entry.title)
                    .font(.title.bold())
                Label(entry.course.rawValue, systemImage: "folder")
                    .foregroundStyle(.secondary)
                Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Divider()
                Text(entry.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
            }
            .padding()
        }
        .navigationTitle("Study Note")
        .navigationBarTitleDisplayMode(.inline)
    }
}
