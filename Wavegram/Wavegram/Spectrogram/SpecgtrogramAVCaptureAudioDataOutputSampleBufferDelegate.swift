//
//  SpecgtrogramAVCaptureAudioDataOutputSampleBufferDelegate.swift
//  Wavegram
//
//  Created by 김제필 on 7/21/22.
//

// MARK: AVCaptureAudioDataOutputSampleBufferDelegate + AVFoundation Support를 위한 코드


import Foundation
import AVFoundation


extension Spectrogram: AVCaptureAudioDataOutputSampleBufferDelegate {

    // MARK: 오디오 캡쳐 정의
    // 관련 문서: https://developer.apple.com/documentation/avfoundation/avcapturedevice
    // captureOutput(_:didOutput:from:) 함수의 콜이 필요함.
    public func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {

        // 보유하고 있는 블록 버퍼로 오디오 버퍼 목록 가져오기
        // MARK: --->
        var audioBufferList = AudioBufferList()
        var blockBuffer: CMBlockBuffer?

        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
            sampleBuffer,
            bufferListSizeNeededOut: nil,
            bufferListOut: &audioBufferList,
            bufferListSize: MemoryLayout.stride(ofValue: audioBufferList),
            blockBufferAllocator: nil,
            blockBufferMemoryAllocator: nil,
            flags: kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment,
            blockBufferOut: &blockBuffer
        )

        guard let data = audioBufferList.mBuffers.mData else {
            // return: raw 오디오 데이터에 대한 포인터
            return
        }
        // MARK: <---


        // nyquistFrequency: 시스템이 재생 가능한 최고 주파수. 일반적으로 시스템 샘플링 레이트의 절반.
        // MARK: 현재 사용되지는 않지만 사용자 인터페이스에 오베레이 추가시 사용될 수 있음.
        if nyquistFrequency == nil {
            let duration = Float(CMSampleBufferGetDuration(sampleBuffer).value)
            let timescale = Float(CMSampleBufferGetDuration(sampleBuffer).timescale)
            let numsamples = Float(CMSampleBufferGetNumSamples(sampleBuffer))
            nyquistFrequency = 0.5 / (duration / timescale / numsamples)
        }


        /*
         스펙트로그램을 그리려면 정확한 sampleCount(여기서는 1024로 정의) 샘플이 필요하지만
         AVFoundation의 오디오 샘플 버퍼에 항상 정확한 1024개 샘플이 포함되어 있지 않을 수 있다.
         따라서 각각의 오디오 샘플 버퍼를 rawAudioData에 추가해서 이런 케이스를 처리한다.
         */
        if self.rawAudioData.count < Spectrogram.sampleCount * 2 {
            // MARK: ---> 데이터에서 배열 생성 -> rawAudioData에 추가
            let actualSampleCount = CMSampleBufferGetNumSamples(sampleBuffer)

            let ptr = data.bindMemory(
                to: Int16.self,
                capacity: actualSampleCount
            )
            let buf = UnsafeBufferPointer(
                start: ptr,
                count: actualSampleCount)

            rawAudioData.append(contentsOf: Array(buf))
            // MARK: <---
        }


        // rawAudioData 배열에 데이터 추가
        //      1. -> raw 오디오 데이터 중 첫 번째 sampleCount가 processData(values: ) 함수로 넘겨짐
        //      2. raw 오디오 데이터에서 hopCount만큼의 데이터 제거
        // bufferCount만큼의 데이터가 아니라 hopCount만큼의 데이터가 제거되는 이유: 데이터를 오버랩을 통한 데이터 로스 방지
        while self.rawAudioData.count >= Spectrogram.sampleCount {
            let dataToProcess = Array(self.rawAudioData[0 ..< Spectrogram.sampleCount])
            self.rawAudioData.removeFirst(Spectrogram.hopCount)
            self.processData(values: dataToProcess)
        }

        createSpectrogram()
    }


    // MARK: 오디오 캡쳐를 위한 환경설정(Configuration)
    // AVCaptureSession 인스턴스 설정
    func configureCaptureSession() {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized:
                    break
            case .notDetermined:
                sessionQueue.suspend()
                AVCaptureDevice.requestAccess(
                    for: .audio,
                    completionHandler: { granted in
                        if !granted {
                            fatalError("App requires microphone access.")
                        } else {
                            self.configureCaptureSession()
                            self.sessionQueue.resume()
                        }
                    })
            return
        default:
            fatalError("App requires microphone access.")
        }


        // MARK: AVCaptureSession 인스턴스의 위치를 마크하기 위한 코드
        // AVCaptureSession은 beginConfiguration() 과 commitConfiguration() 사이에 위치함.

        // MARK: ---> 하단의 commitConfiguration()과 페어
        captureSession.beginConfiguration()

        if captureSession.canAddOutput(audioOutput) {
            captureSession.addOutput(audioOutput)
        } else {
            fatalError("Cannot add an audioOutput.")
        }


        // 세션 캡쳐를 위해 아이폰의 빌트-인 마이크 정의
        guard
            let microphone = AVCaptureDevice.default(
                .builtInMicrophone,
                for: .audio,
                position: .unspecified
            ),
            let microphoneInput = try? AVCaptureDeviceInput(device: microphone) else {
                fatalError("Cannot create the microphone.")
        }

        if captureSession.canAddInput(microphoneInput) {
            captureSession.addInput(microphoneInput)
        }

        // MARK: <--- 윗단의 beginConfiguration()과 페어
        captureSession.commitConfiguration()
    }


    // spectrogram 시작
    func startRunning() {
        sessionQueue.async {
            if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized {
                self.captureSession.startRunning()
            }
        }
    }
}
