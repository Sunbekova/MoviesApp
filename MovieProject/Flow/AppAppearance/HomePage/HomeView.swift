import SwiftUI
import Kingfisher

struct HomeView: View {
    @State private var trendingMovies: [Title] = []
    @State private var topMovies: [Title] = []
    @State private var topTVShows: [Title] = []
    @State private var ongoingTVShows: [Title] = []
    @State private var posterImages: [String] = []
    @State private var selectedPosterIndex: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Featured movies carousel
                    if !trendingMovies.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("This Week")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)

                            CarouselView(
                                movies: Array(trendingMovies.prefix(5)),
                                selectedIndex: $selectedPosterIndex,
                                geometry: geometry
                            )
                            .frame(height: 350)
                        }
                    }


                    // Top 10 Movies
                    SectionView(title: "Top 10 Movies", items: topMovies)

                    // Top 10 TV Shows
                    SectionView(title: "Top 10 TV Shows", items: topTVShows)

                    // Trending Movies list
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Trending Movies")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top)

                        ForEach(trendingMovies, id: \.id) { movie in
                            NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                MovieRow(movie: movie)
                                    .padding(.bottom, -20)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                fetchTrendingMovies()
                fetchTopMovies()
                fetchTopTVShows()
                fetchOngoingTVShows()
            }
        }
    }

    private func fetchTrendingMovies() {
        APICaller.shared.getTrendingMovies { result in
            if case .success(let titles) = result {
                trendingMovies = titles
            }
        }
    }

    private func fetchTopMovies() {
        APICaller.shared.getTrendingMovies { result in
            if case .success(let titles) = result {
                topMovies = Array(titles.prefix(10))
            }
        }
    }

    private func fetchTopTVShows() {
        APICaller.shared.getTopTVShows { result in
            if case .success(let shows) = result {
                topTVShows = Array(shows.prefix(10))
            }
        }
    }

    private func fetchOngoingTVShows() {
        APICaller.shared.getOngoingTVShows { result in
            if case .success(let shows) = result {
                ongoingTVShows = shows
            }
        }
    }
}

struct CarouselView: View {
    var movies: [Title]
    @Binding var selectedIndex: Int
    var geometry: GeometryProxy
    
    var body: some View {
        VStack(spacing: 8) {
            TabView(selection: $selectedIndex) {
                ForEach(Array(movies.prefix(3)).indices, id: \.self) { index in
                    if let posterPath = movies[index].poster_path {
                        KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width * 0.9, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 6)
                            .clipped()
                            .tag(index)
                    } else {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray)
                            .frame(width: geometry.size.width * 0.9, height: 300)
                            .tag(index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 300)

            // Название фильма ЖИРНЫМ
            if movies.indices.contains(selectedIndex) {
                Text(movies[selectedIndex].title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: geometry.size.width * 0.9)
            }
        }
        .frame(height: 340) // 300 постер + 40 для текста и индикатора
    }
}


    
    private func formattedReleaseDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "IN CINEMAS & IMAX MMMM d"
            return dateFormatter.string(from: date).uppercased()
        }
        return "COMING SOON"
    }


// MARK: - Section View
struct SectionView: View {
    var title: String
    var items: [Title]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items, id: \.id) { item in
                        NavigationLink(destination: MovieDetailsView(movie: item)) {
                            VStack(spacing: 8) {
                                KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(item.poster_path ?? "")"))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 220)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .shadow(color: .white.opacity(0.2), radius: 6, x: 0, y: 2)
                                
                                Text(item.title)
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 150)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 24)
    }
}
