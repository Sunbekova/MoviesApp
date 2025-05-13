import SwiftUI
import Kingfisher

struct SearchView: View {
    @State private var searchText = ""
    @State private var movies: [Title] = []
    @State private var trendingMovies: [Title] = []
    @State private var popularMovies: [Title] = []
    @State private var upcomingMovies: [Title] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedCategory: MovieCategory = .trending
    @State private var showFilters = false
    @State private var selectedGenres: Set<Int> = []
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var minRating: Double = 0.0
    @State private var searchHistory: [String] = []
    
    

    enum MovieCategory: String, CaseIterable {
        case trending = "Trending Now"
        case popular = "Most Popular"
        case upcoming = "Upcoming"
    }

    var body: some View {
        VStack {
            BackgroundView()
            HStack {
                Text("Search")
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                    .padding(.leading, 20)
                Spacer()
                
                Button(action: {
                    showFilters.toggle()
                }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 50)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
                
                TextField("Search", text: $searchText, onCommit: {
                    if !searchText.isEmpty {
                        searchMovies(query: searchText)
                        addToSearchHistory(searchText)
                    }
                })
                .foregroundColor(.black)
                .padding(.vertical, 10)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 12)
                    }
                }
            }
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding([.horizontal, .top])
            
            if showFilters {
                FilterView(
                    selectedGenres: $selectedGenres,
                    selectedYear: $selectedYear,
                    minRating: $minRating,
                    onApply: {
                        applyFilters()
                    }
                )
                .transition(.move(edge: .top))
                .animation(.spring(), value: showFilters)
            }
            
            if searchText.isEmpty {
                if !searchHistory.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Recent Searches")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: {
                                searchHistory.removeAll()
                            }) {
                                Text("Clear")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(searchHistory, id: \.self) { query in
                                    Button(action: {
                                        searchText = query
                                        searchMovies(query: query)
                                    }) {
                                        HStack {
                                            Image(systemName: "clock")
                                                .foregroundColor(.gray)
                                            Text(query)
                                                .foregroundColor(.white)
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(15)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(MovieCategory.allCases, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category.rawValue)
                                        .font(.headline)
                                        .foregroundColor(selectedCategory == category ? .red : .white.opacity(0.7))
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(selectedCategory == category ? Color.red.opacity(0.2) : Color.clear)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(selectedMovies.prefix(10)) { movie in
                                Button(action: {
                                    searchText = movie.title
                                    searchMovies(query: movie.title)
                                }) {
                                    VStack(alignment: .leading) {
                                        KFImage(URL(string: movie.posterUrl))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 150)
                                            .cornerRadius(8)
                                            .shadow(radius: 4)
                                        
                                        Text(movie.title)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .frame(width: 100)
                                        
                                        HStack {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 10))
                                            Text(String(format: "%.1f", movie.vote_average))
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                            
                            NavigationLink(destination: CategoryDetailView(category: selectedCategory, movies: selectedMovies)) {
                                VStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 100, height: 150)
                                        .overlay(
                                            VStack {
                                                Image(systemName: "arrow.right")
                                                    .font(.title)
                                                    .foregroundColor(.white)
                                                Text("See All")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                            }
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            
            if isLoading {
                ProgressView("Searching...")
                    .foregroundColor(.gray)
                    .padding()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else if movies.isEmpty && !searchText.isEmpty {
                VStack {
                    Text("No search results")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("Your search results will be displayed here.")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
            } else {
                List(movies, id: \.id) { movie in
                    NavigationLink(destination: MovieDetailsView(movie: movie)) {
                        MovieRow(movie: movie)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
        }
        .navigationTitle("")
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchAllMovies()
            loadSearchHistory()
        }
    }
    
    private var selectedMovies: [Title] {
        switch selectedCategory {
        case .trending:
            return trendingMovies
        case .popular:
            return popularMovies
        case .upcoming:
            return upcomingMovies
        }
    }
    
    private func searchMovies(query: String) {
        guard !query.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let movies):
                    self.movies = movies
                case .failure(let error):
                    self.errorMessage = "Failed to fetch movies: \(error.localizedDescription)"
                    self.movies = []
                }
            }
        }
    }
    
    private func fetchAllMovies() {
        APICaller.shared.getTrendingMovies { result in
            if case .success(let movies) = result {
                DispatchQueue.main.async {
                    self.trendingMovies = movies
                }
            }
        }
        
        APICaller.shared.getPopularMovies { result in
            if case .success(let movies) = result {
                DispatchQueue.main.async {
                    self.popularMovies = movies
                }
            }
        }
        
        APICaller.shared.getUpcomingMovies { result in
            if case .success(let movies) = result {
                DispatchQueue.main.async {
                    self.upcomingMovies = movies
                }
            }
        }
    }
    
    private func addToSearchHistory(_ query: String) {
        if !searchHistory.contains(query) {
            searchHistory.insert(query, at: 0)
            if searchHistory.count > 10 {
                searchHistory.removeLast()
            }
            saveSearchHistory()
        }
    }
    
    private func loadSearchHistory() {
        if let history = UserDefaults.standard.stringArray(forKey: "searchHistory") {
            searchHistory = history
        }
    }
    
    private func saveSearchHistory() {
        UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
    }
    
    private func applyFilters() {
        var filteredMovies = movies
        
        if !selectedGenres.isEmpty {
            filteredMovies = filteredMovies.filter { movie in
                !Set(movie.genre_ids).isDisjoint(with: selectedGenres)
            }
        }
        
        if selectedYear > 0 {
            filteredMovies = filteredMovies.filter { movie in
                if let year = Int(movie.releaseDate.prefix(4)) {
                    return year == selectedYear
                }
                return false
            }
        }
        
        if minRating > 0 {
            filteredMovies = filteredMovies.filter { movie in
                movie.vote_average >= minRating
            }
        }
        
        movies = filteredMovies
        showFilters = false
    }
}

struct FilterView: View {
    @Binding var selectedGenres: Set<Int>
    @Binding var selectedYear: Int
    @Binding var minRating: Double
    let onApply: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Filters")
                .font(.headline)
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(genres, id: \.id) { genre in
                        Button(action: {
                            if selectedGenres.contains(genre.id) {
                                selectedGenres.remove(genre.id)
                            } else {
                                selectedGenres.insert(genre.id)
                            }
                        }) {
                            Text(genre.name)
                                .foregroundColor(selectedGenres.contains(genre.id) ? .white : .gray)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(selectedGenres.contains(genre.id) ? Color.red : Color.gray.opacity(0.2))
                                )
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            HStack {
                Text("Year: \(selectedYear)")
                    .foregroundColor(.white)
                
                Slider(value: Binding(
                    get: { Double(selectedYear) },
                    set: { selectedYear = Int($0) }
                ), in: 1900...Double(Calendar.current.component(.year, from: Date())))
            }
            .padding(.horizontal)
            
            HStack {
                Text("Min Rating: \(String(format: "%.1f", minRating))")
                    .foregroundColor(.white)
                
                Slider(value: $minRating, in: 0...10, step: 0.5)
            }
            .padding(.horizontal)
            
            Button(action: onApply) {
                Text("Apply Filters")
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.red)
                    .cornerRadius(20)
            }
            .padding(.top)
        }
        .padding()
        .background(Color.black.opacity(0.9))
        .cornerRadius(15)
        .padding()
    }
}

struct CategoryDetailView: View {
    let category: SearchView.MovieCategory
    let movies: [Title]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(movies) { movie in
                    NavigationLink(destination: MovieDetailsView(movie: movie)) {
                        VStack {
                            KFImage(URL(string: movie.posterUrl))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .cornerRadius(8)
                                .shadow(radius: 4)
                            
                            Text(movie.title)
                                .font(.caption)
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 10))
                                Text(String(format: "%.1f", movie.vote_average))
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(category.rawValue)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    struct BackgroundView: View {
        var body: some View {
            ZStack {
                // Линейный градиент — от темно-красно-коричневого к чуть светлее
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.14, green: 0.04, blue: 0.01), // #250A02
                        Color(red: 0.25, green: 0.06, blue: 0.02)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                // Радикальный градиент — белое сияние снизу слева
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.9),
                        Color.clear
                    ]),
                    center: .bottomLeading,
                    startRadius: 5,
                    endRadius: 400
                )
                .blendMode(.overlay) // Наложение для мягкого свечения
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
