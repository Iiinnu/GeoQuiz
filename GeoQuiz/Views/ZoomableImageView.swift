import SwiftUI

/// Full-screen presentation for tapping an inline image to look closer — pinch to zoom,
/// drag to pan once zoomed, tap or swipe down to dismiss. Used by Aerial mode's satellite
/// crop, where the inline thumbnail is too small to make out street-level detail.
struct ZoomableImageView: View {
    let assetName: String

    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1
    @State private var committedScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var committedOffset: CGSize = .zero

    private let minScale: CGFloat = 1
    private let maxScale: CGFloat = 5

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Image(assetName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(magnifyGesture)
                .simultaneousGesture(dragGesture)
                .onTapGesture { if scale == minScale { dismiss() } }
                .accessibilityAddTraits(.isImage)
        }
        .overlay(alignment: .topTrailing) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, .black.opacity(0.5))
            }
            .padding()
        }
    }

    private var magnifyGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = min(max(committedScale * value, minScale), maxScale)
            }
            .onEnded { _ in
                committedScale = scale
                if scale == minScale {
                    offset = .zero
                    committedOffset = .zero
                }
            }
    }

    /// Pans the image while zoomed in; while at 1x, a downward swipe dismisses instead.
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard scale > minScale else { return }
                offset = CGSize(
                    width: committedOffset.width + value.translation.width,
                    height: committedOffset.height + value.translation.height
                )
            }
            .onEnded { value in
                if scale > minScale {
                    committedOffset = offset
                } else if value.translation.height > 100 {
                    dismiss()
                }
            }
    }
}
