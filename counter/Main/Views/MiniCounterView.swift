//
//  MiniCounterView.swift
//  nyCounter
//
//  Created by ny on 10/29/24.
//

import SwiftUI

enum ButtonImage: String, CaseIterable {
    case plus = "plus.square"
    case minus = "minus.square"
}

struct CounterViewStyleConfiguration: OptionSet {
    let rawValue: Int
    
    static let reversed: CounterViewStyleConfiguration  = .init(rawValue: 1 << 0)
    static let flipped: CounterViewStyleConfiguration   = .init(rawValue: 1 << 1)
    
    static let hideTitle: CounterViewStyleConfiguration = .init(rawValue: 1 << 2)
    static let hideValue: CounterViewStyleConfiguration = .init(rawValue: 1 << 3)
    static let hideLeft: CounterViewStyleConfiguration  = .init(rawValue: 1 << 4)
    static let hideRight: CounterViewStyleConfiguration = .init(rawValue: 1 << 5)
    
    static let reversedAndFlipped: CounterViewStyleConfiguration = [.reversed, .flipped]
    static let all: CounterViewStyleConfiguration = [.hideTitle, .hideValue, .hideLeft, .hideRight]
}

struct NewCounterView: View {
    @State var counter: NYCounter
    
    @State var styleConfiguration: CounterViewStyleConfiguration = .init()

    var detail: some View {
        VStack {
            if styleConfiguration.contains(.flipped) {
                if !styleConfiguration.contains(.hideValue) {
                    Text("\(counter.value)")
                }
                if !styleConfiguration.contains(.hideTitle) {
                    Text(counter.title)
                }
            } else {
                if !styleConfiguration.contains(.hideTitle) {
                    Text(counter.title)
                }
                if !styleConfiguration.contains(.hideValue) {
                    Text("\(counter.value)")
                }
            }
        }
    }
    
    var countView: some View {
        HStack {
            // Left Button
            if !styleConfiguration.contains(.hideLeft) {
                if styleConfiguration.contains(.hideRight) {
                    Spacer()
                }
                if styleConfiguration.contains(.reversed) {
                    if styleConfiguration.contains(.hideRight) {
                        button(width: 45, height: 45, .plus, counter.increment)
                    } else {
                        button(width: 40, height: 40, .plus, counter.increment)
                    }
                } else {
                    if styleConfiguration.contains(.hideRight) {
                        button(width: 45, height: 45, .minus, counter.decrement)
                    } else {
                        button(width: 40, height: 40, .minus, counter.decrement)
                    }
                }
                if !styleConfiguration.contains(.hideRight) {
                    Spacer()
                }
            } else {
                Spacer()
            }


            // Detail
            detail

            // Right Button
            if !styleConfiguration.contains(.hideRight) {
                if !styleConfiguration.contains(.hideLeft) {
                    Spacer()
                }
                if styleConfiguration.contains(.reversed) {
                    button(width: 45, height: 45, .minus, counter.decrement)
                } else {
                    button(width: 45, height: 45, .plus, counter.increment)
                }
                if styleConfiguration.contains(.hideLeft) {
                    Spacer()
                }
            } else {
                Spacer()
            }
        }
        .frame(minHeight: 30)
        .padding(.vertical, styleConfiguration.isSuperset(of: [.hideLeft, .hideRight]) ? 25 : 0)
        .padding(.vertical, styleConfiguration.isDisjoint(with: .hideTitle) ? 5 : 0)
        .padding(.vertical, styleConfiguration.isDisjoint(with: .hideValue) ? 5 : 0)
        .background {
            Capsule()
                .fill(Color.accent.opacity(0.2))
                .padding(.vertical, 2)
        }
    }
    
    func button(width: CGFloat? = nil, height: CGFloat? = nil, _ image: ButtonImage, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: image.rawValue)
                .resizable()
                .frame(maxWidth: width ?? 40, maxHeight: height ?? width ?? 40)
                .scaledToFit()
        }
        .padding()
    }
    
    var body: some View {
        countView
    }
}

extension NYCounter {
    static var previewCounter: NYCounter { NYCounter(value: 84, title: "Woah!") }
}

extension NewCounterView {
    init(styleConfiguration: CounterViewStyleConfiguration = []) {
        self.init(counter: .previewCounter, styleConfiguration: styleConfiguration)
    }
}

#Preview {
    ScrollView {
        NewCounterView()
        NewCounterView(styleConfiguration: [.reversed])
        NewCounterView(styleConfiguration: [.flipped])
        NewCounterView(styleConfiguration: [.reversedAndFlipped])
        NewCounterView(styleConfiguration: [.hideLeft])
        NewCounterView(styleConfiguration: [.hideRight])
        NewCounterView(styleConfiguration: [.reversed, .hideLeft])
        NewCounterView(styleConfiguration: [.reversed, .hideRight])
        NewCounterView(styleConfiguration: [.hideLeft, .hideRight])
        NewCounterView(styleConfiguration: [.flipped, .hideLeft, .hideRight])
        NewCounterView(styleConfiguration: [.hideTitle, .hideLeft, .hideRight])
        NewCounterView(styleConfiguration: [.hideValue, .hideLeft, .hideRight])
        NewCounterView(styleConfiguration: [.all])
    }
}
