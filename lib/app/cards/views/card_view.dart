import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/card_list_empty_view.dart';
import 'package:moniepoint_flutter/app/cards/views/card_list_item.dart';
import 'package:moniepoint_flutter/app/cards/views/card_view_shimmer.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/add_card_dialog.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

///@author Paul Okeke
class CardScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CardScreen();

}

class _CardScreen extends State<CardScreen> with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late final SingleCardViewModel _viewModel;
  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
  );

  Stream<Resource<List<Card>>> _cardListSource = Stream.empty();

  @override
  void initState() {
    _viewModel = Provider.of<SingleCardViewModel>(context, listen: false);
    _cardListSource = _viewModel.getCards();
    super.initState();
  }

  void _refreshCards() {
    setState(() => _cardListSource = _viewModel.getCards());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
        context: context,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color(0XFFEAF4FF),
          appBar: AppBar(
              centerTitle: false,
              titleSpacing: 0,
              iconTheme: IconThemeData(color: Colors.primaryColor),
              title: Text('Card Management',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.textColorBlack
                  )
              ),
              backgroundColor: Color(0XFFEAF4FF),
              elevation: 0
          ),
          body: StreamBuilder(
              stream: _cardListSource,
              builder: (BuildContext context, AsyncSnapshot<Resource<List<Card>>> snap) {
                if(!snap.hasData || snap.data is Loading) return CardViewShimmer();
                return Column(
                  children: [
                    SizedBox(height: 36),
                    _CardViewTopView(cardSnapshot: snap),
                    SizedBox(height: 24),
                    _CardListView(
                        cardSnapshot: snap,
                        animationController: _animationController,
                        retry: _refreshCards
                    )
                  ],
                );
              }
          ),
        ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

}

///CardTopView
///
///
///
///
///
///
class _CardViewTopView extends StatelessWidget {

  final AsyncSnapshot<Resource<List<Card>>> cardSnapshot;

  _CardViewTopView({required this.cardSnapshot}) : super(key: Key("i-card-top"));

  @override
  Widget build(BuildContext context) {
    final isEmpty = cardSnapshot.hasData && cardSnapshot.data?.data?.isNotEmpty == true;
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Cards',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Visibility(
              visible: isEmpty,
              child: TextButton.icon(
                  onPressed: () {
                    final viewModel = Provider.of<SingleCardViewModel>(context, listen: false);
                    showAddCard(context: context, viewModel: viewModel);
                  },
                  icon: SvgPicture.asset('res/drawables/ic_add.svg'),
                  label: Text(
                    'Add Card',
                    style: TextStyle(color: Colors.primaryColor),
                  )
              )
          )
        ],
      ),
    );
  }

}


/// CardListView
///
///
///
///
///
class _CardListView extends StatelessWidget {

  final List<Card> _currentItems = [];
  final PageController _scrollController = PageController();
  final AnimationController animationController;
  final AsyncSnapshot<Resource<List<Card>>> cardSnapshot;
  final VoidCallback retry;

  _CardListView({
    required this.cardSnapshot,
    required this.animationController,
    required this.retry
  }): super(key: Key("card-list-view"));


  @override
  Widget build(BuildContext context) {
    Tuple<String?, String?>? errorMessage;
    if(cardSnapshot.data is Error) {
      errorMessage = formatError((cardSnapshot.data as Error).message, "Cards");
    }
    return Expanded(
        child: ListViewUtil.makeListViewWithState(
            context: context,
            snapshot: cardSnapshot,
            animationController: animationController,
            currentList: _currentItems,
            emptyPlaceholder: CardListEmptyView(),
            errorLayoutView: ErrorLayoutView(
                errorMessage?.first ?? "Oops",
                errorMessage?.second ?? "",
                this.retry
            ),
            listView: (List<Card>? items) {
              return ListView.separated(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  controller: _scrollController,
                  itemCount: items?.length ?? 0,
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: SizedBox(height: 0),
                  ),
                  itemBuilder: (context, index) {
                    return CardListItem(items![index], index, (card, i) {

                    });
                  });
            }
        )
    );
  }

}

