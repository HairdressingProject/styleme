import 'package:app/widgets/selectable_card.dart';
import 'package:app/widgets/cards_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectFaceShape extends StatefulWidget {
  static final String routeName = '/selectFaceShapeRoute';

  @override
  _SelectFaceShapeState createState() => _SelectFaceShapeState();
}

class _SelectFaceShapeState extends State<SelectFaceShape> {
  List<SelectableCard> _faceShapes;
  SelectableCard _selectedFaceShape;

  @override
  void initState() {
    super.initState();

    _faceShapes = [
      SelectableCard(
        imgPath: 'assets/icons/round.png',
        label: 'Round',
        select: _selectFaceShape,
      ),
      SelectableCard(
          imgPath: 'assets/icons/oval.png',
          label: 'Oval',
          select: _selectFaceShape),
      SelectableCard(
          imgPath: 'assets/icons/square.png',
          label: 'Square',
          selected: true,
          select: _selectFaceShape),
      SelectableCard(
        imgPath: 'assets/icons/diamond.png',
        label: 'Diamond',
        select: _selectFaceShape,
      ),
      SelectableCard(
          imgPath: 'assets/icons/oblong.png',
          label: 'Oblong',
          select: _selectFaceShape),
      SelectableCard(
          imgPath: 'assets/icons/heart.png',
          label: 'Heart',
          select: _selectFaceShape),
    ];

    _selectedFaceShape = _faceShapes[2];
  }

  _selectFaceShape(SelectableCard faceShape) {
    if (!faceShape.selected) {
      setState(() {
        _faceShapes = _faceShapes.map((card) {
          if (card == faceShape) {
            card = SelectableCard(
              imgPath: card.imgPath,
              label: card.label,
              select: _selectFaceShape,
              selected: true,
            );
          } else {
            card = SelectableCard(
              imgPath: card.imgPath,
              label: card.label,
              select: _selectFaceShape,
              selected: false,
            );
          }
          return card;
        }).toList();

        _selectedFaceShape = faceShape;
      });
    }
  }

  _saveChanges() {
    // TODO: save changes with _selectedFaceShape
    print('Selected face shape: ${_selectedFaceShape.label}');
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select a face shape',
            style: TextStyle(fontFamily: 'Klavika'),
          ),
        ),
        body: Scrollbar(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                SvgPicture.asset(
                  'assets/icons/select_face_shape_top.svg',
                  semanticsLabel: 'Select face shape',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Text(
                  'Select your face shape',
                  style: Theme.of(context).textTheme.headline1,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                ),
                Expanded(
                    child: CardsGrid(
                  cards: _faceShapes,
                )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Container(
                  width: 200.0,
                  height: 40.0,
                  child: MaterialButton(
                    disabledColor: Colors.grey[600],
                    disabledTextColor: Colors.white,
                    onPressed: _saveChanges,
                    color: Color.fromARGB(255, 74, 169, 242),
                    minWidth: double.infinity,
                    child: Text(
                      'Save changes',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ],
            ),
          ),
        ));
  }
}
