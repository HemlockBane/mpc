import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';

class UsernameDisplayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UsernameDisplayScreen();
}

class _UsernameDisplayScreen extends State<UsernameDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollView(
        maxHeight: MediaQuery.of(context).size.height,
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Here’s your username',
                    style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 28,),
                  Container(
                    padding: EdgeInsets.only(top: 16, bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.withOpacity(0.12))
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 12,),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.primaryColor.withOpacity(0.1)
                              ),
                              child: SvgPicture.asset('res/drawables/ic_user.svg', width: 32, height: 32,),
                            ),
                            SizedBox(width: 12,),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'CUSTOMER USERNAME',
                                        style: TextStyle(
                                            color: Colors.deepGrey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal
                                        )
                                    ),
                                    SizedBox(height: 4,),
                                    Text(
                                        'bodetomas4life',
                                        style: TextStyle(
                                            color: Colors.textColorBlack,
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                  ],
                                )
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                highlightColor: Colors.primaryColor.withOpacity(0.1),
                                overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(4),
                                onTap: () => Clipboard.setData(ClipboardData(text: "{username}")),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child:   SvgPicture.asset('res/drawables/ic_copy_full.svg', width: 30, height: 30,)
                                ),
                              ),
                            ),
                            SizedBox(width: 12,),
                          ],
                        ),
                        SizedBox(height: 24,),
                        Divider(height: 1, color: Color(0XFFE8EBEF), thickness: 0.6,),
                        SizedBox(height: 4,),
                        TextButton(
                            onPressed: () {
                              print("Proceed to Login.....");
                            },
                            child: Text('Proceed to Login', style: TextStyle(color: Colors.primaryColor),)
                        )
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }
}
