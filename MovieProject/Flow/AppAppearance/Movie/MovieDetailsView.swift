import SwiftUI
import Kingfisher
import WebKit
import FirebaseAuth

struct MovieDetailsView: View {
    var movie: Title
    @State private var trailerState: TrailerState = .loading
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @State private var showHeartOverlay = false
    @State private var dominantColors: (Color, Color) = (.black, .black)

    let userName = Auth.auth().currentUser?.displayName ?? "Anonymous"
    
    enum TrailerState {
        case loading
        case loaded(String)
        case error(String)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [dominantColors.0.opacity(0.6), dominantColors.1.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(movie.title.uppercased())
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.top)

                        HStack(alignment: .top, spacing: 16) {
                            KFImage(URL(string: movie.posterUrl))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width * 0.45, height: 250)
                                .clipped()
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .onAppear {
                                    extractDominantColors()
                                }

                            VStack(alignment: .leading, spacing: 8) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Top Rated")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                    Text("\(String(format: "%.1f", movie.rating))/10")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                }

                                Text("Year: \(movie.releaseDate.prefix(4))")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))

                                Group {
                                    Text("Reduced Game")
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text("James Mangold")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))

                                    Text("Create, to create, play")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))

                                    Divider().background(Color.white.opacity(0.3))

                                    Text("David James Kelly")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7))

                                    Text("Learn")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))

                                    Divider().background(Color.white.opacity(0.3))

                                    Text("Actuar 12th Unit | REVERSITY")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                            .padding(.trailing)
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Trailer")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            Group {
                                switch trailerState {
                                case .loading:
                                    ProgressView("Loading trailer...")
                                        .frame(height: 200)
                                        .frame(maxWidth: .infinity)

                                case .loaded(let url):
                                    WebView(url: url)
                                        .frame(height: 200)
                                        .cornerRadius(8)

                                case .error(let message):
                                    VStack {
                                        Image(systemName: "exclamationmark.triangle")
                                            .font(.largeTitle)
                                            .foregroundColor(.white)
                                        Text("Trailer not available")
                                            .foregroundColor(.white)
                                        Text(message)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Overview")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(movie.description)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(4)
                        }
                        .padding(.horizontal)

                        // Action buttons at the bottom
                        VStack(spacing: 12) {
                            // Add to Favorites button
                            Button(action: toggleFavorite) {
                                HStack {
                                    Image(systemName: favoritesViewModel.isFavorite(movie) ? "heart.fill" : "heart")
                                        .foregroundColor(favoritesViewModel.isFavorite(movie) ? .red : .white)
                                    Text(favoritesViewModel.isFavorite(movie) ? "Remove from Favorites" : "Add to Favorites")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .cornerRadius(10)
                            }

                            // Reviews button
                            NavigationLink(destination: ReviewView(movieId: movie.id, userName: userName)) {
                                HStack {
                                    Image(systemName: "text.bubble")
                                        .foregroundColor(.white)

                                    Text("View & Write Reviews")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadTrailer()
        }
        .overlay(
            Group {
                if showHeartOverlay {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.red)
                        .opacity(0.8)
                        .transition(.scale)
                }
            }
        )
    }

    private func extractDominantColors() {
        guard let url = URL(string: movie.posterUrl) else { return }

        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                let uiImage = imageResult.image
                if let avgColor = uiImage.averageColor {
                    dominantColors.0 = Color(avgColor)
                    dominantColors.1 = Color(avgColor.darker(by: 30) ?? avgColor)
                }
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
    }

    private func loadTrailer() {
        trailerState = .loading
        let searchQuery = "\(movie.title) trailer \(movie.releaseDate.prefix(4))"

        APICaller.shared.getMovie(with: searchQuery) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let video):
                    if !video.id.videoId.isEmpty {
                        let url = "https://www.youtube.com/embed/\(video.id.videoId)"
                        trailerState = .loaded(url)
                    } else {
                        trailerState = .error("No trailer found")
                    }
                case .failure(let error):
                    trailerState = .error(error.localizedDescription)
                    print("Trailer loading failed: \(error.localizedDescription)")
                }
            }
        }
    }

    private func toggleFavorite() {
        if favoritesViewModel.isFavorite(movie) {
            favoritesViewModel.removeFavorite(movie)
        } else {
            favoritesViewModel.addFavorite(movie)
        }
        withAnimation(.spring()) {
            showHeartOverlay = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation {
                showHeartOverlay = false
            }
        }
    }
}

// MARK: - Extensions for Color Analysis
extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: inputImage,
                                                 kCIInputExtentKey: extentVector]),
              let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255,
                       green: CGFloat(bitmap[1]) / 255,
                       blue: CGFloat(bitmap[2]) / 255,
                       alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIColor {
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: max(red - percentage / 100, 0.0),
                           green: max(green - percentage / 100, 0.0),
                           blue: max(blue - percentage / 100, 0.0),
                           alpha: alpha)
        }
        return nil
    }
}

// MARK: - WebView for YouTube Trailer
