import SwiftUI
import Kingfisher
import WebKit

struct HomeView: View {
    @State private var trendingMovies: [Title] = []
    @State private var topMovies: [Title] = []

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    CollapsingHeader()
                        .frame(height: 350)

                    VStack(alignment: .leading) {
                        Text("Top 10 Movies")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.leading)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(topMovies, id: \.id) { movie in
                                    NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                        KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path ?? "")"))
                                            .placeholder { Image(systemName: "photo.artframe") }
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 110, height: 160)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .shadow(radius: 6)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 180)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Trending Movies")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding([.leading, .top])
                        ForEach(trendingMovies, id: \.id) { movie in
                            NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                MovieRow(movie: movie)
                                    .padding(.bottom, 10)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.leading)
                }
            }
            .background(Color(red: 37/255, green: 10/255, blue: 2/255).edgesIgnoringSafeArea(.all))
            .onAppear {
                fetchTrendingMovies()
                fetchTopMovies()
            }
        }
    }

    private func fetchTrendingMovies() {
        APICaller.shared.getTrendingMovies { result in
            switch result {
            case .success(let titles):
                trendingMovies = titles
            case .failure(let error):
                print("Error loading movies: \(error.localizedDescription)")
            }
        }
    }

    private func fetchTopMovies() {
        APICaller.shared.getTrendingMovies { result in
            switch result {
            case .success(let titles):
                topMovies = Array(titles.prefix(10))
            case .failure(let error):
                print("Error loading top movies: \(error.localizedDescription)")
            }
        }
    }
}

struct CollapsingHeader: View {
    var body: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            Image("homepic4")
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: minY > 0 ? 350 + minY : 350)
                .clipped()
                .offset(y: minY > 0 ? -minY : 0)
                .ignoresSafeArea(edges: .top)
        }
        .frame(height: 350)
    }
}

struct UserFormView: View {
    @Binding var userName: String
    @Binding var userEmail: String
    
    let burgundyColor = Color(red: 37/255, green: 10/255, blue: 2/255)
    let whiteColor = Color.white
    let accentColor = Color.red
    
    var body: some View {
        ZStack {
            burgundyColor
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 32) {
                Spacer()
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(radius: 8)
                    .padding(.bottom, 8)
                Text("Welcome")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                VStack(spacing: 20) {
                    CustomTextField(placeholder: "Name", text: $userName)
                        .autocapitalization(.words)
                    CustomTextField(placeholder: "Email", text: $userEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                .padding(.horizontal, 24)
                Button(action: {
                    print("User Name: \(userName), Email: \(userEmail)")
                }) {
                    Text("Sign Up / Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [accentColor, accentColor.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(14)
                        .shadow(color: accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                Spacer()
            }
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    let burgundyColor = Color(red: 37/255, green: 10/255, blue: 2/255)
    let whiteColor = Color.white
    
    var body: some View {
        TextField(placeholder, text: $text)
            .foregroundColor(whiteColor)
            .padding()
            .background(burgundyColor.opacity(0.7))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(whiteColor.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

