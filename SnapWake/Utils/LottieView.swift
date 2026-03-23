import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let contentMode: UIView.ContentMode
    let animationSpeed: CGFloat

    init(
        animationName: String,
        loopMode: LottieLoopMode = .loop,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        animationSpeed: CGFloat = 1.0
    ) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.contentMode = contentMode
        self.animationSpeed = animationSpeed
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear

        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let animationView = uiView.subviews.first as? LottieAnimationView else { return }

        if let path = Bundle.main.path(forResource: animationName, ofType: "json", inDirectory: "Resources/Lottie") {
            animationView.animation = LottieAnimation.filepath(path)
        } else {
            // Fallback: try loading from main bundle
            animationView.animation = LottieAnimation.named(animationName)
        }

        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.play()
    }
}

// Preview
struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            LottieView(animationName: "Handshake Loop")
                .frame(width: 200, height: 200)

            LottieView(animationName: "sun happy")
                .frame(width: 150, height: 150)

            LottieView(animationName: "shining stars")
                .frame(width: 100, height: 100)
        }
    }
}
