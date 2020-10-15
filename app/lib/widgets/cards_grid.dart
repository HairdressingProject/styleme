import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';

class CardsGrid extends StatelessWidget {
  const CardsGrid({Key key, @required this.cards}) : super(key: key);

  final List<SelectableCard> cards;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(5.0),
        mainAxisSpacing: 5.0,
        children: cards);
  }
}
