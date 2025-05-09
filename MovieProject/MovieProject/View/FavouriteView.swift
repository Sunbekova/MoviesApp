import SwiftUI
import Kingfisher

struct FavoriteView: View {
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    init() {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 37/255, green: 10/255, blue: 2/255)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(favoritesViewModel.favoriteMovies) { movie in
                            MovieFavoriteRow(movie: movie) {
                                favoritesViewModel.removeFavorite(movie)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, -80)
                }
            }
            .navigationTitle("Favorite Movies")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing: clearButton)
        }
    }
    
    private var clearButton: some View {
        Button(action: {
            favoritesViewModel.clearAllFavorites()
        }) {
            Text("Clear All")
                .font(.system(size: 18))
                .foregroundColor(.white)
        }
    }
}

struct MovieFavoriteRow: View {
    let movie: Title
    var deleteAction: () -> Void
    
    var body: some View {
        NavigationLink(destination: MovieDetailsView(movie: movie)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 16) {
                    // Movie poster
                    KFImage(URL(string: movie.posterUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 180)
                        .clipped()
                    
                    // Movie information
                    VStack(alignment: .leading, spacing: 8) {
                        Text(movie.title)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(movie.releaseDate ?? "Unknown")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        Text(movie.original_title ?? "Unknown Error")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 18))
                            
                            Text(String(format: "%.1f", movie.vote_average))
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                }
                

                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.5))
            }
            .padding(.vertical, 10)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
