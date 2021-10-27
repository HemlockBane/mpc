import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';


class SavingsAccountItem extends StatelessWidget {
  const SavingsAccountItem({Key? key, this.color = Colors.solidGreen}) : super(key: key);

  final Color color;

  Widget initialView() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          "res/drawables/ic_m_bg.svg",
          fit: BoxFit.cover,
          height: 45,
          width: 45,
          color: color.withOpacity(0.11),
        ),
        Container(
          height: 45,
          width: 45,
          child: Material(
            borderRadius: BorderRadius.circular(17),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(17),
              overlayColor:
              MaterialStateProperty.all(Colors.solidGreen.withOpacity(0.1)),
              highlightColor: Colors.solidGreen.withOpacity(0.05),
              // onTap: () => _onItemClicked(context, beneficiary),
              child: Center(
                child: Text(
                  "LI",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.solidGreen),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 11.87, right: 19.23, top: 14.25, bottom: 14.17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          initialView(),
          SizedBox(
            width: 17,
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leslie Tobechukwu Isah',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.textColorBlack,
                    fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 1,
                ),
                Row(
                  children: [
                    Text(
                      '0011357716',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.textColorBlack
                          .withOpacity(0.5),
                        fontSize: 13),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '₦ 120,459.00',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.textColorBlack
                          .withOpacity(0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            )),
          TextButton(
            onPressed: () {},
            child: Text(
              'Change',
              style: TextStyle(
                color: Colors.solidGreen,
                fontSize: 14,
                fontWeight: FontWeight.bold),
            ),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(40, 0)),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              overlayColor: MaterialStateProperty.all(
                Colors.solidGreen.withOpacity(0.2)),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 8, vertical: 7)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              backgroundColor:
              MaterialStateProperty.all(Colors.transparent)),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 1,
            color: Color(0xff0649AF).withOpacity(0.1))
        ]),
    );
  }
}
