//
//  Modes.swift
//
//
//  Created by Alex Cucos on 05.02.2024.
//

import Foundation

class Modes {
    static let types: [ModeType] = [
        normalVision,
        visionImpairments,
        refractiveErrors,
        colorBlindness
    ]
    
    static let normalVision = ModeType(
        name: nil,
        modes: [
            Mode("No impairments",
                 renderer: nil,
                 description: nil,
                 imageType: .icon("slash.circle"))
        ]
    )
    
    static let visionImpairments = ModeType(
        name: "Vision impairments",
        modes: [
            Mode("Glaucoma",
                 renderer: GlaucomaRenderer(),
                 description:
"""
Glaucoma is a group of diseases which lead to damage of the optic nerve. The common cause is increased pressure within the eye due to age, genetics or certain medications use.

About 80 million people worldwide have glaucoma, 50% being unaware of it. If left untreated, it can lead to complete vision loss.
""",
                 imageType: .image("Glaucoma")),
            Mode("Cataracts",
                 renderer: CataractsRenderer(),
                 description: """
Cataracts cause 51% of all cases of blindness worldwide. The most common cause is aging, but could also be trauma or radiation exposure. Wearing sunglasses, eating vegetables and avoiding smoking reduces the risk of development.

About 20 million are blind due to cataracts. The common way of treatment is eye surgery to replace the cloudy lens with an artificial one.
""",
                 imageType: .image("Cataracts")),
            Mode("Macular degeneration",
                 renderer: MacularDegenerationRenderer(),
                 description:
"""
Also known as age-related macular degeneration, may be the cause of visual halucinations and makes it hard to recognize objects or faces.

There is no way to restore vision lost due to macular degeneration, but avoiding smoking significantly reduces risks. Still, it is highly heritable.

Over 200 million people worldwide have some form of macular degeneration.

This particular example shows wet macular degeneration, which is caracterized by a wet spot instead of a more pronounced, solid one.
""",
                 imageType: .image("Macular degeneration")),
            Mode("Diabetic retinopathy",
                 renderer: DiabeticRetinopahyRenderer(),
                 description:
"""
Diabetic retinopathy damages the retina of patients with diabetes. There are numerous treatments that can prevent severe vision loss and slow or stop development, but there is currently no cure for this impairment.

It is the primary cause of vision loss in developed countries, with over 2 million people suffering from the condition worldwide.
""",
                 imageType: .image("Diabetic retinopathy")),
        ]
    )
    
    static let refractiveErrors = ModeType(
        name: "Refractive errors",
        modes: [
//            Mode("Myopia",
//                 description:
//"""
//
//""",
//                 imageType: .image("Forest")),
//            Mode("Hyperopia",
//                 description:
//"""
//
//""",
//                 imageType: .image("Forest")),
            Mode("Astigmatism",
                 renderer: AstigmatismRenderer(),
                 description:
"""
The prevalence of astigmatism increases with age. Generally, 1 in 3 individuals globally have some sort of this defficiency, as people with myopia or hyperopia also commonly have some form of astigmatism.

Astigmatism can be fixed by refractive surgery or simply wearing glasses or contact lenses. The example shows a developed form of the impairment.
""",
                 imageType: .image("Astigmatism")),
        ]
    )
    
    static let colorBlindness = ModeType(
        name: "Color blindness",
        modes: [
            Mode("Protanomaly",
                 finalFormName: "Protanopia",
                 renderer: ColorBlindnessRenderer(shaderName: "protanopia"),
                 description:
"""
Causes reduced sensitivity to red light and gives red, orange and yellow a green tone. Protanotopia, which is the aggravated form of protanomaly, causes inability to perceive red light at all.

Affects approximately 1% of men.
""",
                 imageType: .image("Protanomaly"),
                 supportsValues: true),
            Mode("Deuteranomaly",
                 finalFormName: "Deuteranopia",
                 renderer: ColorBlindnessRenderer(shaderName: "deuteranopia"),
                 description:
"""
Reduces sensitivity to green colors, making them look red. Deuteranopia, which is the most substancial form of deuteranomaly, results in impossibility to perceive green at all.

Deuteranomaly is the most common type of color blindness, affecting about 5% of men and 0.35% of women worldwide.
""",
                 imageType: .image("Deuteranomaly"),
                 supportsValues: true),
            Mode("Tritanomaly",
                 finalFormName: "Tritanopia",
                 renderer: ColorBlindnessRenderer(shaderName: "tritanopia"),
                 description:
"""
Reduced sensitivity to blue light, which makes blue to appear green-ish and turns yellow to light gray. Is very rare, affecting less than 1% of people worldwide.
""",
                 imageType: .image("Tritanomaly"),
                 supportsValues: true),
            Mode("Monochromacy",
                 renderer: ColorBlindnessRenderer(shaderName: "monochromacy"),
                 description:
"""
Is often referred to as total color blindness, as it removes all of the ability to see color. The person cannot perceive colors although they are able to distinguish them. Monochromats can only sense variations in brightness.

Monochromacy is a very rare condition, affecting only 1 out of 33 000 people worldwide.
""",
                 imageType: .image("Monochromacy"))
        ]
    )
}

struct ModeType: Identifiable {
    let id = UUID()
    
    let name: String?
    let modes: [Mode]
}
