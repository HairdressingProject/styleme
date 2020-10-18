import 'dart:convert';
import 'dart:io';

import 'package:app/models/face_shape.dart';
import 'package:app/models/hair_colour.dart';
import 'package:app/models/hair_style.dart';
import 'package:app/models/history.dart';
import 'package:app/models/picture.dart';
import 'package:app/models/user.dart';
import 'package:app/services/face_shape.dart';
import 'package:app/services/hair_colour.dart';
import 'package:app/services/hair_style.dart';
import 'package:app/services/history.dart';
import 'package:app/services/notification.dart';
import 'package:app/services/pictures.dart';
import 'package:app/views/pages/select_hair_colour.dart';
import 'package:app/views/pages/select_hair_style.dart';
import 'package:app/views/pages/upload_picture.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app/views/layout.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/views/pages/select_face_shape.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef OnPictureUploaded = void Function(
    {@required Picture newPicture,
    @required History historyEntryAdded,
    FaceShape newFaceShape,
    String message});

typedef OnFaceShapeUpdated = void Function(
    {@required FaceShape newFaceShape, String message});

typedef OnHairStyleUpdated = void Function(
    {@required HairStyle newHairStyle, String message});

typedef OnHairColourUpdated = void Function(
    {@required HairStyle newHairStyle, String message});

class Home extends StatefulWidget {
  final User user;
  Home({Key key, @required this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final String routeName = '/homeRoute';

  User _user;
  File _currentPictureFile;
  Future<Picture> _currentPictureFuture;
  Picture _currentPicture;
  FaceShape _currentFaceShape;
  HairStyle _currentHairStyle;
  HairColour _currentHairColour;
  Set<History> _history = Set<History>();
  String _message;
  Set<String> _completedRoutes = Set<String>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _currentPictureFuture = _fetchLatestPictureEntry();
  }

  Future<Set<History>> _fetchUserHistory() async {
    if (_user != null) {
      final historyResponse =
          await HistoryService.getByUserId(userId: _user.id);
      if (historyResponse.statusCode == HttpStatus.ok &&
          historyResponse.body.isNotEmpty) {
        final rawHistory = Set.from(jsonDecode(historyResponse.body));
        return rawHistory.map((e) => History.fromJson(e)).toSet();
      }
    }
    return null;
  }

  Future<Picture> _fetchLatestPictureEntry() async {
    return _fetchUserHistory().then((value) async {
      _history = value;
      if (_history != null && _history.isNotEmpty) {
        final latestPictureEntry =
            await PicturesService.getById(pictureId: _history.last.pictureId);

        if (latestPictureEntry.statusCode == HttpStatus.ok &&
            latestPictureEntry.body.isNotEmpty) {
          final latestPicture =
              Picture.fromJson(jsonDecode(latestPictureEntry.body));

          _completedRoutes.add(UploadPicture.routeName);
          // load latest face shape, hair style and hair colour entries here
          _currentFaceShape = await _fetchLatestFaceShapeEntry();

          if (_currentFaceShape != null) {
            _completedRoutes.add(SelectFaceShape.routeName);
          }

          _currentHairStyle = await _fetchLatestHairStyleEntry();

          if (_currentHairStyle != null) {
            _completedRoutes.add(SelectHairStyle.routeName);
          }

          _currentHairColour = await _fetchLatestHairColourEntry();

          if (_currentHairColour != null) {
            _completedRoutes.add(SelectHairColour.routeName);
          }

          return latestPicture;
        }
      }
      return null;
    });
  }

  Future<HairStyle> _fetchLatestHairStyleEntry() async {
    if (_history != null &&
        _history.isNotEmpty &&
        _history.last.hairStyleId != null) {
      final latestHairStyleResponse =
          await HairStyleService.getById(id: _history.last.hairStyleId);

      if (latestHairStyleResponse.statusCode == HttpStatus.ok &&
          latestHairStyleResponse.body.isNotEmpty) {
        final latestHairStyle =
            HairStyle.fromJson(jsonDecode(latestHairStyleResponse.body));
        return latestHairStyle;
      }
    }
    return null;
  }

  Future<FaceShape> _fetchLatestFaceShapeEntry() async {
    if (_history != null &&
        _history.isNotEmpty &&
        _history.last.faceShapeId != null) {
      final latestFaceShapeResponse =
          await FaceShapeService.getById(id: _history.last.faceShapeId);

      if (latestFaceShapeResponse.statusCode == HttpStatus.ok &&
          latestFaceShapeResponse.body.isNotEmpty) {
        final latestFaceShape =
            FaceShape.fromJson(jsonDecode(latestFaceShapeResponse.body));
        return latestFaceShape;
      }
    }
    return null;
  }

  Future<HairColour> _fetchLatestHairColourEntry() async {
    if (_history != null &&
        _history.isNotEmpty &&
        _history.last.hairColourId != null) {
      final latestHairColourResponse =
          await HairColourService.getById(id: _history.last.hairColourId);

      if (latestHairColourResponse.statusCode == HttpStatus.ok &&
          latestHairColourResponse.body.isNotEmpty) {
        final latestHairColour =
            HairColour.fromJson(jsonDecode(latestHairColourResponse.body));
        return latestHairColour;
      }
    }
    return null;
  }

  void _onPictureUploaded(
      {@required Picture newPicture,
      @required History historyEntryAdded,
      FaceShape newFaceShape,
      String message}) {
    setState(() {
      _completedRoutes.add(UploadPicture.routeName);
      _history.add(historyEntryAdded);
      _currentPicture = newPicture;
      _currentPictureFuture = _fetchLatestPictureEntry();
      _currentFaceShape = newFaceShape;
      _message = message ?? 'Picture successfully uploaded';
    });

    NotificationService.notify(scaffoldKey: scaffoldKey, message: _message);
  }

  void _onFaceShapeUpdated({@required FaceShape newFaceShape, String message}) {
    setState(() {
      _completedRoutes.add(SelectFaceShape.routeName);
      _currentFaceShape = newFaceShape;
      _message = message ?? 'Face shape updated to ${newFaceShape.shapeName}';
    });

    NotificationService.notify(scaffoldKey: scaffoldKey, message: _message);
  }

  void _onHairStyleUpdated({@required HairStyle newHairStyle, String message}) {
    setState(() {
      _completedRoutes.add(SelectHairStyle.routeName);
      _currentHairStyle = newHairStyle;
      _message =
          message ?? 'Hair style updated to ${newHairStyle.hairStyleName}';
    });

    NotificationService.notify(scaffoldKey: scaffoldKey, message: _message);
  }

  void _onHairColourUpdated(
      {@required HairColour newHairColour, String message}) {
    setState(() {
      _completedRoutes.add(SelectHairColour.routeName);
      _currentHairColour = newHairColour;
      _message =
          message ?? 'Hair colour updated to ${newHairColour.colourName}';
    });

    NotificationService.notify(scaffoldKey: scaffoldKey, message: _message);
  }

  void _onPreviewPicture() {
    // TODO: to be implemented
    print('Previewing picture');
  }

  Icon _handleButtonIcon(String currentRoute, String previousRoute) {
    if (_completedRoutes.contains(currentRoute)) {
      return Icon(Icons.check);
    }

    if (previousRoute == null) {
      return Icon(Icons.add);
    }

    if (_completedRoutes.contains(previousRoute)) {
      return Icon(Icons.add);
    } else {
      return Icon(Icons.access_time);
    }
  }

  bool _isButtonEnabled(String currentRoute, String previousRoute) {
    return _completedRoutes.contains(currentRoute) ||
        _completedRoutes.contains(previousRoute);
  }

  @override
  build(BuildContext context) {
    return Layout(
        scaffoldKey: scaffoldKey,
        user: _user,
        title: 'Style Me',
        header: 'Home',
        drawerItems: buildDefaultDrawerItems(context, _user),
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/home_top.svg',
                semanticsLabel: 'Home page logo',
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              Text("Let's get stylish!",
                  style: Theme.of(context).textTheme.headline1),
              FutureBuilder<Picture>(
                future: _currentPictureFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: GestureDetector(
                          onTap: _onPreviewPicture,
                          child: CachedNetworkImage(
                            height: 200.0,
                            imageUrl:
                                '${PicturesService.picturesUri}/file/${snapshot.data.id}',
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress)),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ));
                  }
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Column(children: [
                          Text('A preview of your results will displayed here',
                              style: TextStyle(
                                  fontFamily: 'Klavika',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                          Icon(Icons.image, size: 48)
                        ]),
                      ));
                },
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Your progress",
                    style: Theme.of(context).textTheme.headline2,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: FutureBuilder<Picture>(
                    future: _currentPictureFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CustomButton(
                            icon: _handleButtonIcon(
                                UploadPicture.routeName, null),
                            text: "Select or take picture",
                            alreadySelected: _completedRoutes
                                .contains(UploadPicture.routeName),
                            action: UploadPicture(
                                onPictureUploaded: _onPictureUploaded,
                                user: _user),
                            enabled: true);
                      }
                      return CustomButton(
                          icon: Icon(Icons.access_time),
                          text: "Select or take picture",
                          alreadySelected: false,
                          action: UploadPicture(
                              onPictureUploaded: _onPictureUploaded,
                              user: _user),
                          enabled: true);
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: FutureBuilder<Picture>(
                    future: _currentPictureFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CustomButton(
                          icon: _handleButtonIcon(SelectFaceShape.routeName,
                              UploadPicture.routeName),
                          text: "Select your face shape",
                          action: SelectFaceShape(
                            userId: _user.id,
                            initialFaceShape: _currentFaceShape,
                            onFaceShapeUpdated: _onFaceShapeUpdated,
                          ),
                          alreadySelected: _completedRoutes
                              .contains(SelectFaceShape.routeName),
                          enabled: _isButtonEnabled(SelectFaceShape.routeName,
                              UploadPicture.routeName),
                        );
                      }
                      return CustomButton(
                        icon: Icon(Icons.access_time),
                        text: "Select your face shape",
                        action: SelectFaceShape(
                          userId: _user.id,
                          initialFaceShape: _currentFaceShape,
                          onFaceShapeUpdated: _onFaceShapeUpdated,
                        ),
                        alreadySelected: false,
                        enabled: false,
                      );
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: FutureBuilder<Picture>(
                    future: _currentPictureFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CustomButton(
                            icon: _handleButtonIcon(SelectHairStyle.routeName,
                                SelectFaceShape.routeName),
                            text: "Select a hair style",
                            action: SelectHairStyle(),
                            alreadySelected: _completedRoutes
                                .contains(SelectHairStyle.routeName),
                            enabled: _isButtonEnabled(SelectHairStyle.routeName,
                                SelectFaceShape.routeName));
                      }
                      return CustomButton(
                          icon: Icon(Icons.access_time),
                          text: "Select a hair style",
                          action: SelectHairStyle(),
                          alreadySelected: false,
                          enabled: false);
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: FutureBuilder<Picture>(
                    future: _currentPictureFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CustomButton(
                            icon: _handleButtonIcon(SelectHairColour.routeName,
                                SelectHairStyle.routeName),
                            text: "Colour your hair",
                            enabled: _isButtonEnabled(
                                SelectHairColour.routeName,
                                SelectHairStyle.routeName),
                            alreadySelected: _completedRoutes
                                .contains(SelectHairColour.routeName),
                            action: SelectHairColour(
                              currentPicture: _currentPicture,
                              currentPictureFile: _currentPictureFile,
                            ));
                      }
                      return CustomButton(
                        icon: Icon(Icons.access_time),
                        text: "Select your hair colour",
                        action: SelectHairColour(
                          currentPicture: _currentPicture,
                          currentPictureFile: _currentPictureFile,
                        ),
                        alreadySelected: false,
                        enabled: false,
                      );
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: Icon(Icons.access_time),
                    text: "Save your results",
                    enabled: false,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: Icon(Icons.access_time),
                    text: "Compare results",
                    enabled: false,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: Icon(Icons.access_time),
                    text: "Upload hair style",
                    enabled: false,
                  )),
            ].where((element) => element != null).toList(),
          ),
        ))));
  }
}
