import SwiftUI
import AVKit

struct ContentView: View {
    
    @State private var expandSheet = false
    @Namespace private var animation
    @State private var isPlaying: Bool = false
    
    @StateObject var songManager = SongManager()
    @State private var totalSongDuration: TimeInterval = 0

    
    var body: some View {
        TabView
        {
          HomePage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .environmentObject(songManager)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.ultraThickMaterial, for: .tabBar)
            
            Search()
                .tabItem
            {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .environmentObject(songManager)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
            
            Text("Playlists")
                .tabItem {
                    Image(systemName: "play.rectangle.on.rectangle")
                    Text("Playlsts")
                }
//                .environmentObject(songManager)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarBackground(.ultraThickMaterial, for: .tabBar)
            
            
        }
        .tint(.white)
        .safeAreaInset(edge: .bottom) {
            if !songManager.song.title.isEmpty {
                //CustomBottomSheet
                CustomBottomSheet()
            }
        }
        .overlay(
            MusicView(expandSheet: $expandSheet, animation: animation, isPlaying: $isPlaying)
                .environmentObject(songManager)
                .opacity(expandSheet ? 1 : 0)
//                .offset(y: expandSheet ? 0 : UIScreen.main.bounds.height)
        )
    }
    
    
//Design of CustomBottomSheet
    @ViewBuilder
    func CustomBottomSheet() -> some View {
        ZStack {
            if expandSheet {
                Rectangle()
                    .fill(.clear)
            } else {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay {
                        MusicInfo(expandSheet: $expandSheet, animation: animation, isPlaying: $isPlaying, totalSongDuration: $totalSongDuration)
                            .environmentObject(songManager)
                    }
                    .matchedGeometryEffect(id: "BACKGROUNDVIEW", in: animation)
            }
        }
        .frame(height: 80)
        .offset(y: -49)
    }
}






#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
