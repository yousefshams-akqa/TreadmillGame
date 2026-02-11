import AVFoundation

enum TTSPriority {
    case low
    case normal
    case high
}

class TTSService: NSObject {
    static let shared = TTSService()
    
    private let synthesizer = AVSpeechSynthesizer()
    private var isEnabled: Bool = true
    private var volume: Float = 1.0
    private var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    
    private override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func configure(enabled: Bool, volume: Double, rate: Double) {
        self.isEnabled = enabled
        self.volume = Float(volume)
        self.rate = Float(rate) * (AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate) + AVSpeechUtteranceMinimumSpeechRate
    }
    
    func speak(_ text: String, priority: TTSPriority = .normal) {
        guard isEnabled else { return }
        
        if priority == .high {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.volume = volume
        utterance.rate = rate
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance)
    }
    
    func speakIfEnabled(_ text: String, priority: TTSPriority = .normal) {
        guard isEnabled else { return }
        speak(text, priority: priority)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    var isSpeaking: Bool {
        synthesizer.isSpeaking
    }
}

extension TTSService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
    }
}
