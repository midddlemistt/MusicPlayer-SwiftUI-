import SwiftUI
import AVKit

struct MusicView: View {
    
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    @State private var currentPlaybackTime: TimeInterval = 0
    @State private var totalSongDuration: TimeInterval = 0
    @State private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @Binding var isPlaying: Bool
    
    @EnvironmentObject var songManager: SongManager
    

    
    @ViewBuilder
    func PlayerView(size: CGSize, isPlaying: Binding<Bool>) -> some View {
        VStack {
            VStack {
                Text("\(songManager.song.title)")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("\(songManager.song.artist)")
                    .foregroundStyle(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            HStack {
                Slider(value: Binding(get: {
                    currentPlaybackTime
                }, set: { newValue in
                    seekAudio(to: newValue)
                }), in: 0...totalSongDuration).accentColor(.red)
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            HStack {
                Text(timeString(time: currentPlaybackTime))
                Spacer()
                Text(timeString(time: totalSongDuration))
            }
            
            
            HStack {
                Button(action: {
                    // Действие для кнопки перемешивания
                }) {
                    Image(systemName: "shuffle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                    // Действие для кнопки предыдущего трека
                }) {
                    Image(systemName: "backward.end.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                
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
                
                Button(action: {
                    // Действие для кнопки следующего трека
                }) {
                    Image(systemName: "forward.end.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    // Действие для кнопки повтора
                }) {
                    Image(systemName: "repeat")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .onReceive(timer) { _ in
                if let player = AudioPlayerManager.player {
                    currentPlaybackTime = player.currentTime
                }
            }
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0 , style: .continuous)
                    .fill(.black)
                    .overlay {
                        Rectangle()
                            .fill(.black)
                            .opacity(animateContent ? 1 : 0)
                    }
                    .overlay(alignment: .top) {
                        MusicInfo(expandSheet: $expandSheet, animation: animation, isPlaying: $isPlaying, totalSongDuration: $totalSongDuration)
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BACKGROUNDVIEW", in: animation)
                
                LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
                    .frame(height: 300)
                
                VStack(spacing: 10) {
                    HStack(alignment: .top) {
                        Image(systemName: "chevron.down")
                            .imageScale(.large)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.36)) {
                                    animateContent = false
                                    expandSheet = false
                                }
                            }
                        
                        Spacer()
                        
                        VStack(alignment: .center) {
                            Text("Playlist from album")
                                .opacity(0.5)
                                .font(.caption)
                            Text("Top Hits")
                                .font(.title2)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "ellipsis")
                            .imageScale(.large)
                    }
                    .padding(.horizontal)
                    .padding(.top, 80)
                    
                    GeometryReader { innerGeometry in
                        AsyncImage(url: URL(string: songManager.song.cover)) { img in
                            img.resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                                .background(.white.opacity(0.1))
                                .clipShape(.rect(cornerRadius: 5))
                        }
                        .frame(width: innerGeometry.size.width, height: innerGeometry.size.height)
                        .clipShape(RoundedRectangle(cornerRadius: animateContent ? 100 : 15, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "SONGCOVER", in: animation)
                    
                    PlayerView(size: size, isPlaying: $isPlaying)
                        .onAppear {
                            // Убедитесь, что player не воспроизводится при каждом появлении
                            AudioPlayerManager.player?.pause()
                        }
                        .onChange(of: songManager.song) { newSong in
                            // Если песня меняется, остановите воспроизведение предыдущей и начните новую
                            AudioPlayerManager.player?.pause()
                            totalSongDuration = AudioPlayerManager.player?.duration ?? 0
                            if let audioURL = Bundle.main.url(forResource: newSong.audio_url, withExtension: "mp3", subdirectory: "Music") {
                                AudioPlayerManager.playAudio(from: audioURL)
                            } else {
                                print("Не удалось получить URL для аудио")
                            }
                        }
                        .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                        .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                        .padding(.horizontal, 25)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .contentShape(Rectangle())
                .offset(y: offsetY)
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            let translationY = value.translation.height
//                            offsetY = max(0, translationY)
//                        }
//                        .onEnded { value in
//                            withAnimation(.easeInOut(duration: 0.35)) {
//                                if offsetY > size.height * 0.4 {
//                                    expandSheet = false
//                                    animateContent = false
//                                }
//                            }
//                        }
//                )

                .ignoresSafeArea(.container, edges: .all)
            }
            .ignoresSafeArea(edges: .top)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animateContent = false
                }
            }
            
        }
        
        
    }
}



#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

private func timeString(time: TimeInterval) -> String {
        let minute = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minute, seconds)
    }
 func seekAudio(to time: TimeInterval) {
     AudioPlayerManager.player?.currentTime = time
    }

//Extension for Corner Radius
extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displatCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
            return 0
        }
        return 0
    }
}

