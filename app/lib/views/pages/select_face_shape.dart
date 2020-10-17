import 'package:app/models/face_shape.dart';
import 'package:app/services/notification.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:app/widgets/cards_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectFaceShape extends StatefulWidget {
  static final String routeName = '/selectFaceShapeRoute';
  final FaceShape initialFaceShape;
  final OnFaceShapeUpdated onFaceShapeUpdated;

  SelectFaceShape(
      {Key key, this.initialFaceShape, @required this.onFaceShapeUpdated})
      : super(key: key);

  @override
  _SelectFaceShapeState createState() => _SelectFaceShapeState();
}

class _SelectFaceShapeState extends State<SelectFaceShape> {
  List<SelectableCard> _faceShapes;
  SelectableCard _selectedFaceShape;
  FaceShape _initialFaceShape;
  OnFaceShapeUpdated _onFaceShapeUpdated;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _onFaceShapeUpdated = widget.onFaceShapeUpdated;
    _initialFaceShape = widget.initialFaceShape;

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

    if (_initialFaceShape != null) {
      _selectedFaceShape = _faceShapes.firstWhere(
          (element) =>
              element.label.toLowerCase().contains(_initialFaceShape.shapeName),
          orElse: () => null);

      if (_selectedFaceShape != null) {
        _faceShapes = _faceShapes.map((e) {
          if (e.label == _selectedFaceShape.label) {
            e = SelectableCard(
              imgPath: _selectedFaceShape.imgPath,
              label: _selectedFaceShape.label,
              select: _selectFaceShape,
              selected: true,
            );
          } else {
            e = SelectableCard(
              imgPath: e.imgPath,
              label: e.label,
              select: e.select,
              selected: false,
            );
          }
          return e;
        }).toList();

        Future.delayed(const Duration(seconds: 2), () {
          NotificationService.notify(
              scaffoldKey: _scaffoldKey,
              message:
                  'Your face shape has been detected as ${_selectedFaceShape.label}');
        });
      }
    }
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
    _onFaceShapeUpdated(
        newFaceShape: FaceShape(shapeName: _selectedFaceShape.label));
    setState(() {
      _initialFaceShape = FaceShape(shapeName: _selectedFaceShape.label);
    });
    Navigator.pop(context);
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
