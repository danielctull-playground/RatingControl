
import SwiftUI

struct RatingControl: View {

    @Binding var value: Value

    var body: some View {
        HStack(spacing: 1) {
            ForEach(Value.allCases) { value in
                Button(action: { self.value = value }) {
                    Segment(filled: value <= self.value)
                }
            }
        }
        .frame(height: 10)
    }
}

extension RatingControl {

    enum Value: CaseIterable, Comparable {
        case one, two, three, four, five
    }
}

extension RatingControl.Value: Identifiable {
    var id: Self { self }
}

extension RatingControl {
    fileprivate struct Segment: View {
        let filled: Bool
        var body: some View {
            filled ? Color.blue : .gray
        }
    }
}
