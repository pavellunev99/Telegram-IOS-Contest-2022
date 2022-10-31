//
//  ColorSelectorViewController.swift
//  Telegram_IOS_Contest_2022
//
//  Created by Павел Лунев on 31.10.2022.
//

import UIKit

protocol ColorSelectorViewDelegate: AnyObject {
    func colorSelectorViewTapPipette()
    func colorSelectorDidSelectColor(_ color: UIColor)
}

final class ColorSelectorViewController: ViewController {

    weak var delegate: ColorSelectorViewDelegate?

    let navigationView = NavigationBar()
    let editorControl = UISegmentedControl(items: ["Grid", "Spectrum", "Sliders"])

    let gridSelector = SpectrumSelectorView()
    let spectrumSelector = SpectrumSelectorView()
    let slidersSelector = View()
    let opacitySelector = View()
    let savedColors = View()

    var selectedColor: UIColor?

    override func setup() {
        super.setup()

        view.backgroundColor = .black.withAlphaComponent(0.6)

        navigationView.delegate = self
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationView)

        editorControl.translatesAutoresizingMaskIntoConstraints = false
        editorControl.selectedSegmentIndex = 0
        editorControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        editorControl.backgroundColor = .white.withAlphaComponent(0.1)
        view.addSubview(editorControl)

        gridSelector.translatesAutoresizingMaskIntoConstraints = false
        gridSelector.isHidden = false
        gridSelector.delegate = self
        gridSelector.elementSize = 20
        view.addSubview(gridSelector)

        spectrumSelector.translatesAutoresizingMaskIntoConstraints = false
        spectrumSelector.isHidden = true
        spectrumSelector.delegate = self
        spectrumSelector.elementSize = 1
        view.addSubview(spectrumSelector)

        slidersSelector.translatesAutoresizingMaskIntoConstraints = false
        slidersSelector.isHidden = true
        view.addSubview(slidersSelector)

        opacitySelector.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(opacitySelector)

        savedColors.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(savedColors)
    }

    override func setupSizes() {
        super.setupSizes()

        navigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        navigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true

        editorControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        editorControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        editorControl.topAnchor.constraint(equalTo: navigationView.bottomAnchor, constant: 18).isActive = true

        gridSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        gridSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        gridSelector.topAnchor.constraint(equalTo: editorControl.bottomAnchor, constant: 20).isActive = true
        gridSelector.heightAnchor.constraint(equalToConstant: 300).isActive = true

        spectrumSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        spectrumSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        spectrumSelector.topAnchor.constraint(equalTo: editorControl.bottomAnchor, constant: 20).isActive = true
        spectrumSelector.heightAnchor.constraint(equalToConstant: 300).isActive = true

        slidersSelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        slidersSelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        slidersSelector.topAnchor.constraint(equalTo: editorControl.bottomAnchor, constant: 20).isActive = true
        slidersSelector.heightAnchor.constraint(equalToConstant: 300).isActive = true

        opacitySelector.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        opacitySelector.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        opacitySelector.topAnchor.constraint(equalTo: gridSelector.bottomAnchor, constant: 20).isActive = true
        opacitySelector.heightAnchor.constraint(equalToConstant: 68).isActive = true

        savedColors.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        savedColors.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        savedColors.topAnchor.constraint(equalTo: opacitySelector.bottomAnchor, constant: 20).isActive = true
        //savedColors.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        savedColors.heightAnchor.constraint(equalToConstant: 82).isActive = true
    }

    @objc
    private func indexChanged(_ control: UISegmentedControl) {
        switch control.selectedSegmentIndex {
        case 0:
            gridSelector.isHidden       = false
            spectrumSelector.isHidden   = true
            slidersSelector.isHidden    = true
        case 1:
            gridSelector.isHidden       = true
            spectrumSelector.isHidden   = false
            slidersSelector.isHidden    = true
        case 2:
            gridSelector.isHidden       = true
            spectrumSelector.isHidden   = true
            slidersSelector.isHidden    = false
        default:
            break
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        guard let selectedColor = selectedColor else { return }
        delegate?.colorSelectorDidSelectColor(selectedColor)
    }
}

extension ColorSelectorViewController: ColorSelectorNavigationViewDelegate {

    func navigationViewTapClose() {
        dismiss(animated: true)
    }

    func navigationViewTapPipette() {
        delegate?.colorSelectorViewTapPipette()
    }
}

extension ColorSelectorViewController: SpectrumSelectorViewDelegate {

    func specturmSelectorColorSelected(_ color: UIColor) {
        delegate?.colorSelectorDidSelectColor(color)
    }
}
