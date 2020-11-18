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
  final int initialFaceShapeId;
  final OnFaceShapeUpdated onFaceShapeUpdated;
  // final List<FaceShape> allFaceShapes;
  final int userId;
  // final bool faceShapeAlreadyDetected;

  SelectFaceShape({
    Key key,
    this.initialFaceShapeId,
    @required this.onFaceShapeUpdated,
    @required this.userId,
    // this.allFaceShapes,
    // this.faceShapeAlreadyDetected
  }) : super(key: key);

  @override
  _SelectFaceShapeState createState() => _SelectFaceShapeState();
}

class _SelectFaceShapeState extends State<SelectFaceShape> {
  int _userId;
  bool _isLoading = false;
  Future<List<FaceShape>> _faceShapesFuture;
  List<FaceShape> _faceShapes;
  List<SelectableCard> _faceShapeCards;
  SelectableCard _selectedFaceShape;
  FaceShape _initialFaceShape;
  OnFaceShapeUpdated _onFaceShapeUpdated;
  bool _alreadyNotified;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _onFaceShapeUpdated = widget.onFaceShapeUpdated;
    _alreadyNotified = false;
    _userId = widget.userId;
    _faceShapesFuture = _fetchAllFaceShapes();
  }

  void _notifyInitialFaceShape(FaceShape fs) {
    if (!_alreadyNotified) {
      Future.delayed(const Duration(seconds: 1), () {
        NotificationService.notify(
            scaffoldKey: _scaffoldKey,
            message: 'Your face shape has been detected as ${fs.label}');
      }).then((value) {
        setState(() {
          _alreadyNotified = true;
        });
      });
    }
  }

  Future<List<FaceShape>> _fetchAllFaceShapes() async {
    final faceShapeService = FaceShapeService();

    // try to retrieve locally first
    final allfaceShapes = await faceShapeService.getAllLocal();
    List<FaceShape> faceShapes = List<FaceShape>();

    if (allfaceShapes.isNotEmpty) {
      // got face shapes
      faceShapes = List.generate(allfaceShapes.length,
          (index) => FaceShape.fromJson(allfaceShapes[index]));
    } else {
      final allFaceShapesResponse = await faceShapeService.getAll();

      if (allFaceShapesResponse.statusCode == HttpStatus.ok &&
          allFaceShapesResponse.body.isNotEmpty) {
        final rawFaceShapes =
            jsonDecode(allFaceShapesResponse.body)['face_shapes'];
        final rawFaceShapesList = List.from(rawFaceShapes);
        if (rawFaceShapesList.isNotEmpty) {
          faceShapes =
              rawFaceShapesList.map((e) => FaceShape.fromJson(e)).toList();

          if (faceShapes.isNotEmpty) {
            // insert into local db
            faceShapes.forEach((element) {
              faceShapeService.postLocal(obj: element.toJson());
            });
          }
        }
      }
    }

    setState(() {
      if (widget.initialFaceShapeId != null) {
        _initialFaceShape = faceShapes
            .firstWhere((element) => element.id == widget.initialFaceShapeId);

        _notifyInitialFaceShape(_initialFaceShape);
      }

      _faceShapeCards = _buildFaceShapeCards(faceShapes);
    });

    return faceShapes;
  }

  List<SelectableCard> _buildFaceShapeCards(List<FaceShape> faceShapes) {
    return faceShapes
        .map((e) => SelectableCard(
              id: e.id,
              imgPath: 'assets/icons/${e.shapeName.toLowerCase()}.jpg',
              label: e.label,
              select: _selectFaceShape,
              selected: _initialFaceShape != null
                  ? e.id == _initialFaceShape.id
                  : false,
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
              child: FutureBuilder(
                future: _faceShapesFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
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
                    );
                  } else if (snapshot.hasError) {
                    return Column(
                      children: [
                        const Icon(
                          Icons.error,
                          size: 128,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Text(
                          snapshot.error.toString(),
                          style: TextStyle(
                              fontFamily: 'Klavika',
                              fontSize: 14,
                              letterSpacing: .05),
                        )
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
        ));
  }
}
