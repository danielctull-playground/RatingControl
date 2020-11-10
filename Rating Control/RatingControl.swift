
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
                .frame(height: 10)

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

    private struct Segments: View {
        @Binding var value: Value

        private func drag(percentage: CGFloat) {
            let values = Value.allCases
            let offset = Int(floor(CGFloat(values.count) * percentage))
            let limitedOffset = max(0, min(values.count - 1, offset))
            value = values[values.index(values.startIndex, offsetBy: limitedOffset)]
        }

        var body: some View {
            HStack(spacing: 1) {
                ForEach(Value.allCases) { value in
                    Segment(filled: value <= self.value)
                        .onTapGesture { self.value = value }
                }
            }
            .onDragGesture { drag(percentage: $0.x) }
        }
    }

    private struct Segment: View {
        let filled: Bool
        var body: some View {
            filled ? Color.blue : .gray
        }
    }
}

extension View {

    fileprivate func onDragGesture(
        _ f: @escaping (CGPoint) -> ()
    ) -> some View {
        GeometryReader { geometry in
            gesture(DragGesture().onChanged { drag in
                let x = drag.location.x / geometry.size.width
                let y = drag.location.y / geometry.size.height
                f(CGPoint(x: x, y: y))
            })
        }
    }
}
