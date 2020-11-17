import 'dart:convert';
import 'dart:io';

import 'package:app/models/face_shape.dart';
import 'package:app/models/history.dart';
import 'package:app/services/face_shape.dart';
import 'package:app/services/history.dart';
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
  final List<FaceShape> allFaceShapes;
  final int userId;
  final bool faceShapeAlreadyDetected;

  SelectFaceShape(
      {Key key,
      this.initialFaceShape,
      @required this.onFaceShapeUpdated,
      @required this.userId,
      this.allFaceShapes,
      this.faceShapeAlreadyDetected})
      : super(key: key);

  @override
  _SelectFaceShapeState createState() => _SelectFaceShapeState();
}

class _SelectFaceShapeState extends State<SelectFaceShape> {
  int _userId;
  bool _isLoading = false;
  List<FaceShape> _faceShapes;
  List<SelectableCard> _faceShapeCards;
  SelectableCard _selectedFaceShape;
  FaceShape _initialFaceShape;
  OnFaceShapeUpdated _onFaceShapeUpdated;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _faceShapes = widget.allFaceShapes;
    _onFaceShapeUpdated = widget.onFaceShapeUpdated;
    _initialFaceShape = widget.initialFaceShape;
    _userId = widget.userId;
    _faceShapeCards = _buildFaceShapeCards(_faceShapes);
    _selectedFaceShape = _faceShapeCards
        .firstWhere((element) => element.id == _initialFaceShape.id);

    if (!widget.faceShapeAlreadyDetected) {
      Future.delayed(const Duration(seconds: 2), () {
        NotificationService.notify(
            scaffoldKey: _scaffoldKey,
            message:
                'Your face shape has been detected as ${_initialFaceShape.label}');
      });
    }
  }

  Future<List<FaceShape>> _fetchAllFaceShapes() async {
    final faceShapeService = FaceShapeService();

    final allFaceShapesResponse = await faceShapeService.getAll();

    if (allFaceShapesResponse.statusCode == HttpStatus.ok &&
        allFaceShapesResponse.body.isNotEmpty) {
      final rawFaceShapes =
          jsonDecode(allFaceShapesResponse.body)['face_shapes'];
      final rawFaceShapesList = List.from(rawFaceShapes);
      if (rawFaceShapesList.isNotEmpty) {
        return rawFaceShapesList.map((e) => FaceShape.fromJson(e)).toList();
      }
    }
    return List<FaceShape>();
  }

  List<SelectableCard> _buildFaceShapeCards(List<FaceShape> faceShapes) {
    return faceShapes
        .map((e) => SelectableCard(
              id: e.id,
              imgPath: 'assets/icons/${e.shapeName.toLowerCase()}.jpg',
              label: e.label,
              select: _selectFaceShape,
              selected: e.id == _initialFaceShape.id,
            ))
        .toList();
  }

  _selectFaceShape(SelectableCard faceShape) {
    if (!faceShape.selected) {
      setState(() {
        _faceShapeCards = _faceShapeCards.map((card) {
          if (card.id == faceShape.id) {
            card = SelectableCard(
              id: card.id,
              imgPath: card.imgPath,
              label: card.label,
              select: _selectFaceShape,
              selected: true,
            );
          } else {
            card = SelectableCard(
              id: card.id,
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

  _saveChanges() async {
    setState(() {
      _isLoading = true;
    });
    final faceShapeEntry = HistoryAddFaceShape(
        userId: _userId, faceShapeId: _selectedFaceShape.id);

    final historyService = HistoryService();

    final response =
        await historyService.postFaceShapeEntry(faceShapeEntry: faceShapeEntry);

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      _onFaceShapeUpdated(
          newFaceShape: _faceShapes.firstWhere(
        (element) => element.id == _selectedFaceShape.id,
        orElse: () => null,
      ));
      setState(() {
        _isLoading = false;
        _initialFaceShape = _faceShapes.firstWhere(
          (element) => element.id == _initialFaceShape.id,
          orElse: () => null,
        );
      });
      Navigator.pop(context);
    } else {
      NotificationService.notify(
          scaffoldKey: _scaffoldKey, message: 'Could not updated face shape');
    }
    setState(() {
      _isLoading = false;
    });
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
                  cards: _faceShapeCards,
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
                    onPressed: !_isLoading
                        ? () async {
                            await _saveChanges();
                          }
                        : null,
                    color: Color.fromARGB(255, 74, 169, 242),
                    minWidth: double.infinity,
                    child: !_isLoading
                        ? Text(
                            'Save changes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.white),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
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
