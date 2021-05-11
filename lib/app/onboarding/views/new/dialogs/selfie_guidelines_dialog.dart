import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class SelfieGuideLines {
  static Widget getLayout(BuildContext context) {
    final controller = PageController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16),
        Text('Selfie Guidelines',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.darkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
        SizedBox(height: 13),
        Expanded(
            flex: 1,
            child: PageView(
              controller: controller,
              children: [
                _selfieGuidelineOne(),
                _selfieGuidelineTwo(),
                _selfieGuidelineThree(),
              ],
            )),
        SizedBox(height: 16),
        Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Styles.appButton(
              onClick: () {
                Navigator.pop(context);
              },
              text: 'Continue'),
        ),
        SizedBox(height: 48),
      ],
    );
  }

  static Widget _selfieGuidelineOne() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
            ),
            Expanded(
                child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'res/drawables/guideline_face_one.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  child: SvgPicture.asset('res/drawables/ic_selfie_cancel.svg'),
                  bottom: -16,
                  right: -10,
                )
              ],
            )),
            SizedBox(
              width: 16,
            ),
            Expanded(
                child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'res/drawables/guideline_face_two.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  child:
                      SvgPicture.asset('res/drawables/ic_selfie_checked.svg'),
                  bottom: -16,
                  right: -10,
                )
              ],
            )),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        SizedBox(
          height: 22,
        ),
        Text('Facial Expression',
            style: TextStyle(
                fontSize: 22,
                color: Colors.darkBlue,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: 16,
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 54),
            child: Text(
                'Your photo should show you alone looking directly at the camera with a neutral expression and your mouth closed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.darkLightBlue,
                    fontWeight: FontWeight.normal))),
      ],
    );
  }

  static Widget _selfieGuidelineTwo() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 16,
            ),
            Expanded(
                child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'res/drawables/guideline_face_three.png',
                    fit: BoxFit.contain,
                  ),
                )
              ],
            )),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'res/drawables/guideline_face_three1.png',
                    fit: BoxFit.contain,
                  ),
                )
              ],
            )),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        SizedBox(
          height: 22,
        ),
        Text('Facial Features',
            style: TextStyle(
                fontSize: 22,
                color: Colors.darkBlue,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: 16,
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 54),
            child: Text(
                'Your photo should show your eyes open, eyes and ears clearly visible—no hair across your eyes or ears.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.darkLightBlue,
                    fontWeight: FontWeight.normal)))
      ],
    );
  }

  static Widget _selfieGuidelineThree() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 16,
            ),
            Expanded(
                child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'res/drawables/guideline_face_four.png',
                    fit: BoxFit.contain,
                  ),
                )
              ],
            )),
            SizedBox(
              width: 8,
            ),
            Expanded(
                child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'res/drawables/guideline_face_four1.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                )
              ],
            )),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        SizedBox(
          height: 22,
        ),
        Text('Background & Surroundings',
            style: TextStyle(
                fontSize: 22,
                color: Colors.darkBlue,
                fontWeight: FontWeight.bold)),
        SizedBox(
          height: 16,
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 54),
            child: Text(
                'Your photo should be be taken with a plain light-coloured background, with uniform lighting and not show shadows or flash reflections on your face and no red eye.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.darkLightBlue,
                    fontWeight: FontWeight.normal))
        )
      ],
    );
  }
}
