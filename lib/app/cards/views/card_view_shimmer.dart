import 'package:flutter/material.dart' hide Colors, Card;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:shimmer/shimmer.dart';

class CardViewShimmer extends StatelessWidget{

  Widget _listContainer({Widget? child}) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      height: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: Colors.primaryColor.withOpacity(0.01),
                offset: Offset(0, -1),
                blurRadius: 3,
                spreadRadius: 0
            )
          ]
      ),
      child: child,
    );
  }

  Widget _rowItem() {
    return Shimmer.fromColors(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
          child: Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                    color: Color(0XFFE3E8EB).withOpacity(0.5),
                    shape: BoxShape.circle
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 250,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color(0XFFE3E8EB).withOpacity(0.5),
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          width: 100,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Color(0XFFE3E8EB).withOpacity(0.5),
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        )
                      ]
                  )),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: Color(0XFFE3E8EB).withOpacity(0.5),
                    shape: BoxShape.circle
                ),
              ),
              SizedBox(width: 2),
            ],
          ),
        ),
        baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
        highlightColor: Colors.grey.withOpacity(0.3)
    );
  }

  Widget _pagingView() {
    return Column(
      children: [
        SizedBox(height: 16,),
        _rowItem(),
        Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
          child: Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        _rowItem(),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        _rowItem(),
      ],
    );
  }

  Widget _cardList(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 4),
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.9,
                    blurRadius: 16
                )
              ]
          ),
          child: Stack(
            children: [
              Shimmer.fromColors(
                  child: Container(
                    padding: EdgeInsets.only(top: 28, left: 24, right: 24, bottom: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Color(0XFFE3E8EB).withOpacity(0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(8))
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: Color(0XFFE3E8EB).withOpacity(0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(8))
                                  ),
                                ),
                                SizedBox(width: 4,),
                                Container(
                                  width: 80,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Color(0XFFE3E8EB).withOpacity(0.5),
                                      borderRadius: BorderRadius.all(Radius.circular(8))
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 42,),
                        Container(
                          width:200,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Color(0XFFE3E8EB).withOpacity(0.5),
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                        ),
                        SizedBox(height: 42,),
                        Flexible(child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 20,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Color(0XFFE3E8EB).withOpacity(0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(8))
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Color(0XFFE3E8EB).withOpacity(0.5),
                                  borderRadius: BorderRadius.all(Radius.circular(8))
                              ),
                            )
                          ],
                        ),)
                      ],
                    ),
                  ),
                  baseColor: Color(0XFFE3E8EB).withOpacity(0.5),
                  highlightColor: Colors.grey.withOpacity(0.3)
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
        Container(
          width: 20,
          height: 5,
          decoration: BoxDecoration(
              color: Color(0XFFE3E8EB).withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(8))
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
            top: 170,
            bottom: 0,
            right: 0,
            left: 0,
            child: _listContainer(
                child: _pagingView()
            )
        ),
        Positioned(
            right: 42,
            left: 42,
            top: 24,
            child: Container(
              child: _cardList(context),
            )
        ),
      ],
    );
  }

}