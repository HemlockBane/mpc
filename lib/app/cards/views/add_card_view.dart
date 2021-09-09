import 'package:flutter/material.dart' hide Colors, Card;
import 'package:moniepoint_flutter/app/cards/views/card_list_empty_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';

class AddCardScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AddCardScreen();

}

class _AddCardScreen extends State<AddCardScreen> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
        context: context,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0XFFEAF4FF),
          appBar: AppBar(
              centerTitle: false,
              titleSpacing: -12,
              iconTheme: IconThemeData(color: Colors.primaryColor),
              title: Text('Add Card',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.darkBlue,
                      fontFamily: Styles.defaultFont,
                      fontSize: 17
                  )
              ),
              backgroundColor: Color(0XFFEAF4FF),
              elevation: 0
          ),
          body: Column(
            children: [
              SizedBox(height: 36,),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Cards',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              Expanded(child: CardListEmptyView(),)
            ],
          ),
        ),
    );
  }

}