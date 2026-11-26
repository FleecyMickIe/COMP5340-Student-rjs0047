
import SwiftUI

struct EntryCardView: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.title)
                .font(.headline)
                .foregroundStyle(.primary)
            Text(entry.course.rawValue)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(entry.text)
                .font(.body)
                .foregroundStyle(.primary)
                .lineLimit(2)
            Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
