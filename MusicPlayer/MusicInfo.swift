import SwiftUI
import AVKit

struct MusicInfo: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    @Binding var isPlaying: Bool
    @Binding var totalSongDuration: TimeInterval
    @EnvironmentObject var songManager: SongManager
    @State private var currentPlaybackTime: TimeInterval = 0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 0) {
            
            ZStack {
                if !expandSheet {
                    GeometryReader { geometry in
                        let size = geometry.size
                        
                        AsyncImage(url: URL(string: songManager.song.cover)) { img in
                            img.resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                                .background(Color.white.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        .frame(width: size.width, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .opacity(expandSheet ? 0 : 1)
                        .offset(y: expandSheet ? size.height : 0)
                        
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: size.width * CGFloat(currentPlaybackTime / totalSongDuration), height: 4)
                        }

                                            }
                    .matchedGeometryEffect(id: "SONGCOVER", in: animation)
                }
            }
            .frame(width: 50, height: 50)
            
            VStack {
                Text("\(songManager.song.title)")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .padding(.horizontal, 15)
                    .opacity(expandSheet ? 0 : 1)
                
                Text("\(songManager.song.artist)")
                    .foregroundStyle(.gray)
                    .opacity(expandSheet ? 0 : 1)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
            
            Button(action: {
                $isPlaying.wrappedValue.toggle()
                if $isPlaying.wrappedValue {
                    AudioPlayerManager.player?.play()
                } else {
                    AudioPlayerManager.player?.pause()
                }
            }) {
                Image(systemName: $isPlaying.wrappedValue ? "pause.fill" : "play.fill")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
            .frame(width: 50, height: 50)
            .opacity(expandSheet ? 0 : 1)
        }
        .foregroundStyle(.white)
        .padding(.horizontal)
        .frame(height: 80)
        
        .onTapGesture {
            // Expanding BottomSheet
            withAnimation(.easeInOut(duration: 0.3)) {
                expandSheet.toggle()
            }
        }
        .onReceive(timer) { _ in
            if let player = AudioPlayerManager.player {
                currentPlaybackTime = player.currentTime
            }
        }
    }
    
   
}



#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}




