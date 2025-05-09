import SwiftUI
import Kingfisher
import WebKit

struct MovieDetailsView: View {
    var movie: Title
    @State private var trailerState: TrailerState = .loading
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @State private var showHeartOverlay = false
    
    enum TrailerState {
        case loading
        case loaded(String)
        case error(String)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 50) {
                
                switch trailerState {
                case .loading:
                    ProgressView("Loading trailer...")
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    
                case .loaded(let url):
                    WebView(url: url)
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    
                case .error(let message):
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                        Text("Trailer not available")
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }
                
                // Favorite Button
                Button(action: toggleFavorite) {
                    HStack {
                        Image(systemName: favoritesViewModel.isFavorite(movie) ? "heart.fill" : "heart")
                        Text(favoritesViewModel.isFavorite(movie) ? "Remove from Favorites" : "Add to Favorites")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1.5)
                    )
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Movie Info
                HStack(alignment: .top, spacing: 16) {
                    KFImage(URL(string: movie.posterUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 180)
                        .cornerRadius(0)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(movie.title)
                            .font(.title2)
                            .bold()
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", movie.rating))
                        }
                        
                        Text(movie.releaseDate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .foregroundColor(.white)
                
                // Overview
                VStack(alignment: .leading, spacing: 8) {
                    Text("Overview")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(movie.description)
                        .font(.body)
                        .foregroundColor(.white)
                }
                .padding()
                
                Spacer()
            }
            .padding(.vertical)
        }
        .background(Color(red: 37/255, green: 10/255, blue: 2/255).edgesIgnoringSafeArea(.all))
        .navigationTitle(movie.title)
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

struct WebView: View {
    let url: String
    
    var body: some View {
        WebViewContainer(url: URL(string: url)!)
            .edgesIgnoringSafeArea(.all)
    }
}

struct WebViewContainer: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}
