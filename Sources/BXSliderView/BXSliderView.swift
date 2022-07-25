//
//  SliderView.swift
//  BoxueApp
//
//  Created by Mars on 2022/3/29.
//
import UIKit
import SwiftUI

public class CustomSlider: UISlider {
  let height: CGFloat
  
  public required init(height: CGFloat) {
    self.height = height
    super.init(frame: .zero)
  }
  
//  override public init(frame: CGRect) {
//    height = 0
//    super.init(frame: frame)
//  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func trackRect(forBounds bounds: CGRect) -> CGRect {
    var result = super.trackRect(forBounds: bounds)
    result.size.height = height
    
    return result
  }
}


public struct BXSliderView: UIViewRepresentable {
  @Binding var value: Float
  let height: CGFloat
  let onChanged: () -> Void
  let onEnded: () -> Void
  
  public init(
    value: Binding<Float>,
    height: CGFloat = 2.0,
    onChanged: @escaping () -> Void = {},
    onEnded: @escaping () -> Void = {}) {
    self._value = value
    self.height = height
    self.onChanged = onChanged
    self.onEnded = onEnded
  }
  
  public func makeUIView(context: Context) -> CustomSlider {
    let slider = CustomSlider(height: height)
    
    let thumb = UIImage(named: "thumb", in: Bundle.module, with: nil)
    
    slider.minimumTrackTintColor = .red
    slider.maximumTrackTintColor = UIColor(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 0.4))
    slider.setThumbImage(thumb, for: .normal)
    
    slider.addTarget(
      context.coordinator,
      action: #selector(context.coordinator.changed(slider:)),
      for: .valueChanged
    )
    
    slider.value = value
    
    return slider
  }
  
  public func updateUIView(_ uiView: CustomSlider, context: Context) {
    uiView.value = value
  }
  
  public func makeCoordinator() -> SliderCoordinator {
    return SliderCoordinator(parent: self)
  }
}


public class SliderCoordinator: NSObject {
  var parent: BXSliderView
  
  init(parent: BXSliderView) {
    self.parent = parent
  }
  
  @MainActor @objc func changed(slider: CustomSlider) {
    if slider.isTracking {
      parent.onChanged()
    }
    else {
      parent.onEnded()
    }
  }
}
