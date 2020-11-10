
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
