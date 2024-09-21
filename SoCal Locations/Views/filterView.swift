//
//  filterView.swift
//  Locations
//
//  Created by August Wetterau on 11/17/21.
//

import SwiftUI

struct filterView: View {
    
    @EnvironmentObject var filter: currentFilter
    @State var percentage: Double = 50

    private var selectColor = Color.green
    
    var body: some View {
        VStack() {

            HStack() {
            Text("Tags:")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top)
                .padding(.leading)
            Spacer()
            }
                
            HStack() {
                Spacer()
                VStack(alignment: .leading) {
                    
                    Button(action: {
                                
                                if !filter.isAbandoned {
                                    filter.isAbandoned = true
                                filter.filterTagList.append("Abandoned")
                                } else {
                                    filter.isAbandoned = false
                                    if let index = filter.filterTagList.firstIndex(of: "Abandoned") {
                                        filter.filterTagList.remove(at: index)
                                    }
                                }
                            }) {
                                if !filter.isAbandoned {
                                    HStack() {
                                        ZStack() {
                                            Circle()
                                                .stroke(Color.primary, lineWidth: 2)
                                                .frame(width: 30, height: 30)
                                            
                                        }
                                        Text("Abandoned")
                                            .bold()
                                            .foregroundColor(.primary)
                                            .font(.title3)
                                    }
                                } else {
                                    ZStack() {
                                        
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 2)
                                            .frame(width: 30, height: 30)
                                            .background(Circle()
                                                            .fill(selectColor))
                                        Image(systemName: "checkmark")
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.primary)
                                        
                                    }
                                    Text("Abandoned")
                                        .bold()
                                        .foregroundColor(selectColor)
                                        .font(.title3)
                                }
                            }
                    
                    Button(action: {
                        filter.isFavorite.toggle()
                    }) {
                        if !filter.isFavorite {
                            HStack() {
                                ZStack() {
                                    Circle()
                                        .stroke(Color.primary, lineWidth: 2)
                                        .frame(width: 30, height: 30)
                                    
                                }
                                Text("Favorites")
                                    .bold()
                                    .foregroundColor(.primary)
                                    .font(.title3)
                            }
                        } else {
                            ZStack() {
                                
                                Circle()
                                    .stroke(Color.primary, lineWidth: 2)
                                    .frame(width: 30, height: 30)
                                    .background(Circle()
                                                    .fill(selectColor))
                                Image(systemName: "checkmark")
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.primary)
                                
                            }
                            Text("Favorite")
                                .bold()
                                .foregroundColor(selectColor)
                                .font(.title3)
                        }
                    }

                    Button(action: {
                                
                                if !filter.userLocation {
                                    filter.userLocation = true
                                filter.filterTagList.append("userLocation")
                                } else {
                                    filter.userLocation = false
                                    if let index = filter.filterTagList.firstIndex(of: "userLocation") {
                                        filter.filterTagList.remove(at: index)
                                    }
                                }
                            }) {
                                if !filter.userLocation {
                                    HStack() {
                                        ZStack() {
                                            Circle()
                                                .stroke(Color.primary, lineWidth: 2)
                                                .frame(width: 30, height: 30)
                                            
                                        }
                                        Text("User Discovered")
                                            .bold()
                                            .foregroundColor(.primary)
                                            .font(.title3)
                                    }
                                } else {
                                    ZStack() {
                                        
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 2)
                                            .frame(width: 30, height: 30)
                                            .background(Circle()
                                                            .fill(selectColor))
                                        Image(systemName: "checkmark")
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.primary)
                                        
                                    }
                                    Text("User Discovered")
                                        .bold()
                                        .foregroundColor(selectColor)
                                        .font(.title3)
                                }
                            }
                    
                }
                Spacer()
                VStack(alignment: .leading) {

                    Button(action: {
                                
                                if !filter.isView {
                                    filter.isView = true
                                filter.filterTagList.append("View")
                                } else {
                                    filter.isView = false
                                    if let index = filter.filterTagList.firstIndex(of: "View") {
                                        filter.filterTagList.remove(at: index)
                                    }
                                }
                            }) {
                                if !filter.isView {
                                    HStack() {
                                        ZStack() {
                                            Circle()
                                                .stroke(Color.primary, lineWidth: 2)
                                                .frame(width: 30, height: 30)
                                            
                                        }
                                        Text("View")
                                            .bold()
                                            .foregroundColor(.primary)
                                            .font(.title3)
                                    }
                                } else {
                                    ZStack() {
                                        
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 2)
                                            .frame(width: 30, height: 30)
                                            .background(Circle()
                                                            .fill(selectColor))
                                        Image(systemName: "checkmark")
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.primary)
                                        
                                    }
                                    Text("View")
                                        .bold()
                                        .foregroundColor(selectColor)
                                        .font(.title3)
                                }
                            }
                    
                    Button(action: {
                                
                                if !filter.isFood {
                                    filter.isFood = true
                                filter.filterTagList.append("Food")
                                } else {
                                    filter.isFood = false
                                    if let index = filter.filterTagList.firstIndex(of: "Food") {
                                        filter.filterTagList.remove(at: index)
                                    }
                                }
                            }) {
                                if !filter.isFood {
                                    HStack() {
                                        ZStack() {
                                            Circle()
                                                .stroke(Color.primary, lineWidth: 2)
                                                .frame(width: 30, height: 30)
                                            
                                        }
                                        Text("Food")
                                            .bold()
                                            .foregroundColor(.primary)
                                            .font(.title3)
                                    }
                                } else {
                                    ZStack() {
                                        
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 2)
                                            .frame(width: 30, height: 30)
                                            .background(Circle()
                                                            .fill(selectColor))
                                        Image(systemName: "checkmark")
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.primary)
                                        
                                    }
                                    Text("Food")
                                        .bold()
                                        .foregroundColor(selectColor)
                                        .font(.title3)
                                }
                            }
                    
                    Button(action: {
                                
                                if !filter.isRoad {
                                    filter.isRoad = true
                                filter.filterTagList.append("Road")
                                } else {
                                    filter.isRoad = false
                                    if let index = filter.filterTagList.firstIndex(of: "Road") {
                                        filter.filterTagList.remove(at: index)
                                    }
                                }
                            }) {
                                if !filter.isRoad {
                                    HStack() {
                                        ZStack() {
                                            Circle()
                                                .stroke(Color.primary, lineWidth: 2)
                                                .frame(width: 30, height: 30)
                                            
                                        }
                                        Text("Road")
                                            .bold()
                                            .foregroundColor(.primary)
                                            .font(.title3)
                                    }
                                } else {
                                    ZStack() {
                                        
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 2)
                                            .frame(width: 30, height: 30)
                                            .background(Circle()
                                                            .fill(selectColor))
                                        Image(systemName: "checkmark")
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(.primary)
                                        
                                    }
                                    Text("Road")
                                        .bold()
                                        .foregroundColor(selectColor)
                                        .font(.title3)
                                }
                            }
                    

                }
                Spacer()
            
            }

        Spacer()
                .navigationTitle("Filter")
    }
    }
}

struct filterView_Previews: PreviewProvider {
    static var previews: some View {
        filterView()
    }
}


struct CustomSliderComponents {
    let barLeft: CustomSliderModifier
    let barRight: CustomSliderModifier
    let knob: CustomSliderModifier
}
struct CustomSliderModifier: ViewModifier {
    enum Name {
        case barLeft
        case barRight
        case knob
    }
    let name: Name
    let size: CGSize
    let offset: CGFloat

    func body(content: Content) -> some View {
        content
        .frame(width: size.width)
        .position(x: size.width*0.5, y: size.height*0.5)
        .offset(x: offset)
    }
}

struct CustomSlider<Component: View>: View {

    @Binding var value: Double
    var range: (Double, Double)
    var knobWidth: CGFloat?
    let viewBuilder: (CustomSliderComponents) -> Component
   
    init(value: Binding<Double>, range: (Double, Double), knobWidth: CGFloat? = nil,
         _ viewBuilder: @escaping (CustomSliderComponents) -> Component
    ) {
        _value = value
        self.range = range
        self.viewBuilder = viewBuilder
        self.knobWidth = knobWidth
    }

    
    var body: some View {
      return GeometryReader { geometry in
        self.view(geometry: geometry) 
      }
    }

    private func view(geometry: GeometryProxy) -> some View {
      let frame = geometry.frame(in: .global)
      let drag = DragGesture(minimumDistance: 0).onChanged({ drag in
        self.onDragChange(drag, frame) }
      )
      let offsetX = self.getOffsetX(frame: frame)

      let knobSize = CGSize(width: knobWidth ?? frame.height, height: frame.height)
      let barLeftSize = CGSize(width: CGFloat(offsetX + knobSize.width * 0.5), height:  frame.height)
      let barRightSize = CGSize(width: frame.width - barLeftSize.width, height: frame.height)

      let modifiers = CustomSliderComponents(
          barLeft: CustomSliderModifier(name: .barLeft, size: barLeftSize, offset: 0),
          barRight: CustomSliderModifier(name: .barRight, size: barRightSize, offset: barLeftSize.width),
          knob: CustomSliderModifier(name: .knob, size: knobSize, offset: offsetX))

      return ZStack { viewBuilder(modifiers).gesture(drag) }
    }
    private func onDragChange(_ drag: DragGesture.Value,_ frame: CGRect) {
        let width = (knob: Double(knobWidth ?? frame.size.height), view: Double(frame.size.width))
        let xrange = (min: Double(0), max: Double(width.view - width.knob))
        var value = Double(drag.startLocation.x + drag.translation.width)
        value -= 0.5*width.knob
        value = value > xrange.max ? xrange.max : value
        value = value < xrange.min ? xrange.min : value
        value = value.convert(fromRange: (xrange.min, xrange.max), toRange: range)
        self.value = value
    }
    
    private func getOffsetX(frame: CGRect) -> CGFloat {
        let width = (knob: knobWidth ?? frame.size.height, view: frame.size.width)
        let xrange: (Double, Double) = (0, Double(width.view - width.knob))
        let result = self.value.convert(fromRange: range, toRange: xrange)
        return CGFloat(result)
    }
}

extension Double {
    func convert(fromRange: (Double, Double), toRange: (Double, Double)) -> Double {
        var value = self
        value -= fromRange.0
        value /= Double(fromRange.1 - fromRange.0)
        value *= toRange.1 - toRange.0
        value += toRange.0
        return value
    }
}

