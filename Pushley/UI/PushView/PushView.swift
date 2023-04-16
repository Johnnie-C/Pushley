//
//  PushView.swift
//  Pushley
//
//  Created by Johnnie Cheng on 6/3/20.
//  Copyright © 2020 Johnnie Cheng. All rights reserved.
//

import SwiftUI

struct PushView<ViewModel: PushViewModelProtocol>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            certificateView
            
            
            HStack(alignment: .center, spacing: 45) {
                environmentView
                pushTypeView
                Spacer()
            }
            .padding(.bottom, 10)
            
            topicView
            optionsView
            pushDataView
            logView
            
            HStack(alignment: .center) {
                Button(action: {
                    self.viewModel.resetIfNeeded()
                }) { Text("Reset") }
                    .buttonStyle(SimpleButtonStyle(style: .blue))
                Spacer()
                Button(action: {
                    self.viewModel.send()
                }) { Text("Send") }
            }
        }
        .padding(10)
        .frame(minWidth: 800, maxWidth: .infinity,
               minHeight: 800, maxHeight: .infinity)
    }
    
    private var certificateView: some View {
        VStack(alignment: .leading) {
            Picker("Certificate type:", selection: $viewModel.certificateType) {
                Text(".p12").tag(CertificateType.p12)
                Text(".p8").tag(CertificateType.p8)
            }
            .frame(maxWidth: 250)
            .pickerStyle(SegmentedPickerStyle())
            
            if viewModel.certificateType == .p8 {
                HStack(spacing: 20) {
                    HStack(alignment: .center) {
                        Text("Key ID:")
                        TextField("", text: $viewModel.keyID)
                            .cornerRadius(5)
                            .focusable()
                            .frame(maxWidth: 200)
                    }
                    HStack(alignment: .center) {
                        Text("Issuer ID:")
                        TextField("", text: $viewModel.issuerID)
                            .cornerRadius(5)
                            .focusable()
                            .frame(maxWidth: 400)
                    }
                    Spacer()
                }
            }
            
            HStack(alignment: .center) {
                if let certificate = viewModel.certificate {
                    Text(certificate.label)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(
                                    Color(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0),
                                    lineWidth: 1
                                )
                        )
                }
                Button(
                    action:{ self.viewModel.showCertificatePicker() },
                    label: { Text("Select...") }
                )
                Spacer()
            }
            Divider().padding(.vertical, 12)
        }
    }
    
    private var environmentView: some View {
        Picker("Environment:", selection: $viewModel.environment) {
            Text("Production").tag(Environment.production)
            Text("Sandbox").tag(Environment.sandbox)
        }
        .frame(maxWidth: 350)
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private var pushTypeView: some View {
        Picker("Push Type: ", selection: $viewModel.pushType) {
            Text(PushType.alert.rawValue).tag(PushType.alert)
            Text(PushType.background.rawValue).tag(PushType.background)
            Text(PushType.voip.rawValue).tag(PushType.voip)
        }
        .frame(maxWidth: 400)
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private var topicView: some View {
        HStack(alignment: .center) {
            Text("Topic:")
            TextField("Your app bundle Id", text: $viewModel.topic)
                .cornerRadius(5)
                .focusable()
        }
        .padding(.bottom, 10)
    }
    
    private var optionsView: some View {
        HStack(alignment: .center, spacing: 30) {
            Checkbox(label: "content-available", isChecked: $viewModel.contentAvailable)
                .fixedSize()
            Checkbox(label: "mutable-content", isChecked: $viewModel.mutableContent)
                .fixedSize()
        }
        .padding(.bottom, 10)
    }
    
    private var pushDataView: some View {
        VStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Extra Data(Optional):")
                NSScrollableTextViewWrapper(text: $viewModel.extraDataJson,
                                            didEndEditing: { self.viewModel.formatExtraDataJson() })
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                )
                    .cornerRadius(5)
            }
            .padding(.bottom, 10)
            .frame(maxHeight: 200)
            
            HStack(alignment: .center) {
                Text("Title:")
                TextField("", text: $viewModel.notificationTitle)
                    .cornerRadius(5)
                    .focusable()
            }
            
            HStack(alignment: .center) {
                Text("Body:")
                TextField("", text: $viewModel.notificationBody)
                    .cornerRadius(5)
                    .focusable()
            }
            
            HStack(alignment: .center) {
                Text("Device Token:")
                TextField("", text: $viewModel.deviceToken)
                    .cornerRadius(5)
                    .focusable()
            }
            .padding(.bottom, 15)
        }
    }
    
    private var logView: some View {
        ZStack(alignment: .bottomTrailing) {
            NSScrollableTextViewWrapper(isEditable: false,
                                        textSize: 13,
                                        text: $viewModel.log)
                .padding(.top, 5)
                .padding(.bottom, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .cornerRadius(5)
            
            Button(action: { self.viewModel.clearLog() }) {
                Image(nsImage: NSImage(named: NSImage.refreshTemplateName) ?? NSImage())
            }
                .frame(width: 40, height: 40)
                .buttonStyle(SimpleButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

struct PushView_Previews: PreviewProvider {
    
    static var previews: some View {
        PushView(viewModel: PushViewModel())
    }
    
}
