import SharedMacro
import SwiftUI

final class ViewModel {
    @Shared var count: Int
    
    init(count: Int) {
        self.$count = Shared(count)
    }
}


