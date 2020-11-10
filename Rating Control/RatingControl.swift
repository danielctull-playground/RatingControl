
import SwiftUI

struct RatingControl<Value>: View
    where
    Value: CaseIterable,
    Value.AllCases: RandomAccessCollection,
    Value: Comparable,
    Value: CustomStringConvertible,
    Value: Identifiable
{

    let title: String
    @Binding var value: Value

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)

            Segments(value: $value)

            Text(value.description)
                .font(.callout)

        }
        .accessibilityElement()
        .accessibilityLabel(title)
        .accessibilityValue(value.description)
        .accessibilityAdjustableAction(adjust)
    }
}

extension RatingControl {

    private func adjust(direction: AccessibilityAdjustmentDirection) {
        let values = Value.allCases
        guard values.count > 1 else { return }
        guard let index = values.firstIndex(of: value) else { return }
        switch direction {
        case .increment:
            guard index < values.index(before: values.endIndex) else { return }
            value = values[values.index(after: index)]
        case .decrement:
            guard index > values.startIndex else { return }
            value = values[values.index(before: index)]
        @unknown default:
            return
        }
    }
}

extension RatingControl {

    fileprivate struct Segments: View {
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

    fileprivate struct Segment: View {
        let filled: Bool
        var body: some View {
            filled ? Color.blue : .gray
        }
    }
}
