import SwiftUI
import Kingfisher

struct MovieRow: View {
    let movie: Title
    
    var shortDescription: String {
        let desc = movie.overview ?? "No description available."
        if desc.count > 80 {
            let index = desc.index(desc.startIndex, offsetBy: 80)
            return desc[..<index] + "..."
        } else {
            return desc
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path ?? "")"))
                .placeholder { Image(systemName: "photo.artframe") }
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(radius: 6)

            VStack(alignment: .leading, spacing: 8) {
                Text(movie.original_title ?? movie.original_name ?? "Unknown Title")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 18))
                    Text(String(format: "%.1f", movie.vote_average))
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.medium)
                }

                Text(shortDescription)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(3)
                    .padding(.top, 2)
            }
            Spacer()
        }
        .padding(16)
        .background(Color(red: 27/255, green: 7/255, blue: 2/255).opacity(0.95))
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
    }
}
