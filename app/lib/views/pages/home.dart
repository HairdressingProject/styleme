import 'dart:convert';
import 'dart:io';

import 'package:app/models/face_shape.dart';
import 'package:app/models/hair_colour.dart';
import 'package:app/models/hair_length.dart';
import 'package:app/models/hair_style.dart';
import 'package:app/models/history.dart';
import 'package:app/models/model_picture.dart';
import 'package:app/models/picture.dart';
import 'package:app/models/user.dart';
import 'package:app/services/authentication.dart';
import 'package:app/services/constants.dart';
import 'package:app/services/face_shape.dart';
import 'package:app/services/hair_colour.dart';
import 'package:app/services/hair_length.dart';
import 'package:app/services/hair_style.dart';
import 'package:app/services/history.dart';
import 'package:app/services/model_pictures.dart';
import 'package:app/services/notification.dart';
import 'package:app/services/pictures.dart';
import 'package:app/views/pages/history_view.dart';
import 'package:app/views/pages/select_hair_colour.dart';
import 'package:app/views/pages/select_hair_style.dart';
import 'package:app/views/pages/upload_picture.dart';
import 'package:app/widgets/action_button.dart';
import 'package:app/widgets/compare_to_original.dart';
import 'package:app/widgets/preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app/views/layout.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/views/pages/select_face_shape.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

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
    {@required HairColour newHairColour, String message});

class Home extends StatefulWidget {
  final User user;
  Home({Key key, @required this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // static final String routeName = '/homeRoute';

  User _user;
  Image _currentPictureFile;
  Future<Picture> _currentPictureFuture;
  Picture _currentPicture;
  List<HairLength> _allHairLengths;
  List<HairStyle> _allHairStyles;
  List<ModelPicture> _allModelPictures;
  FaceShape _currentFaceShape;
  HairStyle _currentHairStyle;
  HairColour _currentHairColour;
  List<History> _history = List<History>();
  History _latestHistoryEntry;
  String _message;
  bool _faceShapeAlreadyDetected = false;
  String _userToken;
  List<String> _completedRoutes = List<String>();
  bool _isDiscardChangesLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  Picture _originalPicture;
  // Picture _currentPictureNoColour;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _currentPictureFuture = _fetchLatestPictureEntry();
  }

  Future<String> _getUserToken() async {
    final token = await Authentication.retrieveToken();
    return token;
  }

  Future<History> _fetchLatestUserHistoryEntry() async {
    if (_user != null) {
      final historyService = HistoryService();
      final pictureService = PicturesService();

      // try to retrieve latest history entry locally first
      History latestHistoryEntry =
          await historyService.getLatestUserHistoryEntryLocal(userId: _user.id);

      if (latestHistoryEntry != null) {
        final currentPictureMap =
            await pictureService.getByIdLocal(id: latestHistoryEntry.pictureId);
        final originalPictureMap = await pictureService.getByIdLocal(
            id: latestHistoryEntry.originalPictureId);

        setState(() {
          _currentPicture = Picture.fromJson(currentPictureMap);
          _originalPicture = Picture.fromJson(originalPictureMap);
        });

        return latestHistoryEntry;
      } else {
        // could not retrieve history entry locally, try to retrieve it from the API
        final latestEntryResponse =
            await historyService.getLatestUserHistoryEntry(userId: _user.id);

        if (latestEntryResponse != null &&
            latestEntryResponse.statusCode == 200 &&
            latestEntryResponse.body.isNotEmpty) {
          final body = jsonDecode(latestEntryResponse.body);

          latestHistoryEntry = History.fromJson(body['history_entry']);

          setState(() {
            if (body['current_picture'] != null) {
              _currentPicture = Picture.fromJson(body['current_picture']);
            }

            if (body['original_picture'] != null) {
              _originalPicture = Picture.fromJson(body['original_picture']);
            }
          });

          // save it locally
          await historyService.postLocal(obj: latestHistoryEntry.toJson());

          if (_currentPicture != null) {
            await pictureService.postLocal(obj: _currentPicture.toJson());
          }

          if (_originalPicture != null) {
            await pictureService.postLocal(obj: _originalPicture.toJson());
          }

          return latestHistoryEntry;
        }
      }
    }
    return null;
  }

  /// Retrieves the latest history entry for the user signed in,
  /// then retrieves the latest picture uploaded by said user
  Future<Picture> _fetchLatestPictureEntry() async {
    final userToken = await _getUserToken();

    return _fetchLatestUserHistoryEntry().then((history) async {
      setState(() {
        _latestHistoryEntry = history;
        _userToken = userToken;

        if (_latestHistoryEntry != null) {
          _completedRoutes.add(SelectFaceShape.routeName);

          if (_latestHistoryEntry.hairStyleId != null) {
            _completedRoutes.add(SelectHairStyle.routeName);
          } else {
            _completedRoutes.remove(SelectHairStyle.routeName);
          }

          if (_latestHistoryEntry.hairColourId != null) {
            _completedRoutes.add(SelectHairColour.routeName);
          } else {
            _completedRoutes.remove(SelectHairColour.routeName);
          }
        } else {
          _completedRoutes.remove(SelectFaceShape.routeName);
          _completedRoutes.remove(SelectHairColour.routeName);
          _completedRoutes.remove(SelectHairStyle.routeName);
        }
      });

      print('Current picture: $_currentPicture');

      if (_currentPicture == null) {
        return Picture(id: -1);
      }
      return _currentPicture;
    }).catchError((err) {
      print('Could not fetch user history');
      print(err);
      return Picture(id: -1);
    });
  }

  void _onPictureUploaded(
      {@required Picture newPicture,
      @required History historyEntryAdded,
      FaceShape newFaceShape,
      String message}) {
    setState(() {
      _currentPictureFuture = _fetchLatestPictureEntry();
      _completedRoutes.clear();
      _completedRoutes.add(UploadPicture.routeName);
      _history.add(historyEntryAdded);
      _currentPicture = newPicture;
      _currentFaceShape = newFaceShape;
      _message = message ?? 'Picture successfully uploaded';
    });

    NotificationService.notify(scaffoldKey: scaffoldKey, message: _message);
  }

  void _onFaceShapeUpdated(
      {@required FaceShape newFaceShape,
      @required History newHistoryEntry,
      String message}) {
    setState(() {
      _currentPictureFuture = _fetchLatestPictureEntry();
      _completedRoutes.clear();
      _completedRoutes.add(UploadPicture.routeName);
      _completedRoutes.add(SelectFaceShape.routeName);
      _currentFaceShape = newFaceShape;
      _message = message ?? 'Face shape updated to ${newFaceShape.label}';
      _faceShapeAlreadyDetected = true;
    });

    NotificationService.notify(scaffoldKey: scaffoldKey, message: _message);
  }

  void _onHairStyleUpdated({@required HairStyle newHairStyle, String message}) {
    setState(() {
      _currentPictureFuture = _fetchLatestPictureEntry();
      _completedRoutes.clear();
      _completedRoutes.add(UploadPicture.routeName);
      _completedRoutes.add(SelectFaceShape.routeName);
      _completedRoutes.add(SelectHairStyle.routeName);
      _currentHairStyle = newHairStyle;
      _message = message ?? 'Hair style updated to ${newHairStyle.label}';
    });

    NotificationService.notify(scaffoldKey: scaffoldKey, message: _message);
  }

  void _onHairColourUpdated(
      {@required HairColour newHairColour, String message}) {
    setState(() {
      _currentPictureFuture = _fetchLatestPictureEntry();
      _completedRoutes.clear();
      _completedRoutes.add(UploadPicture.routeName);
      _completedRoutes.add(SelectFaceShape.routeName);
      _completedRoutes.add(SelectHairStyle.routeName);
      _completedRoutes.add(SelectHairColour.routeName);
      _currentHairColour = newHairColour;
      _message = message ?? 'Hair colour updated to ${newHairColour.label}';
    });

    NotificationService.notify(scaffoldKey: scaffoldKey, message: _message);
  }

  void _onPreviewPicture() {
    if (_userToken == null || _userToken.isEmpty) {
      NotificationService.notify(
          scaffoldKey: scaffoldKey,
          message: 'Invalid user token. Please sign in again.');
      return;
    }

    if (_currentPicture == null) {
      NotificationService.notify(
          scaffoldKey: scaffoldKey,
          message: 'Current picture not found. Please restart the app.');
      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Preview(
            previewPictureUrl:
                '${PicturesService.picturesUri}/file/${_currentPicture.id}',
            userToken: _userToken,
          ),
        ));
  }

  Icon _handleButtonIcon(String currentRoute, String previousRoute) {
    if (_completedRoutes.contains(currentRoute)) {
      return Icon(Icons.check);
    }

    if (previousRoute == null) {
      return Icon(Icons.add);
    }

    if (_completedRoutes.contains(previousRoute) ||
        currentRoute == SelectHairColour.routeName &&
            _isButtonEnabled(currentRoute, SelectHairStyle.routeName)) {
      return Icon(Icons.add);
    } else {
      return Icon(Icons.access_time);
    }
  }

  bool _isButtonEnabled(String currentRoute, String previousRoute) {
    if (currentRoute == SelectHairColour.routeName) {
      return _completedRoutes.contains(SelectFaceShape.routeName);
    }
    return _completedRoutes.contains(currentRoute) ||
        _completedRoutes.contains(previousRoute);
  }

  _onCompareToOriginal() {
    if (_userToken == null || _userToken.isEmpty) {
      NotificationService.notify(
          scaffoldKey: scaffoldKey,
          message: 'Invalid user token. Please sign in and try again.');
      return;
    }

    if (_history == null || _history.isEmpty) {
      NotificationService.notify(
          scaffoldKey: scaffoldKey,
          message:
              'Your history is empty. Please restart the app or make changes and try again.');
      return;
    }

    final originalPictureId = _history.last.originalPictureId;
    final currentPictureId = _currentPicture.id;

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompareToOriginal(
            originalPictureUrl:
                '${PicturesService.picturesUri}/file/$originalPictureId',
            currentPictureUrl:
                '${PicturesService.picturesUri}/file/$currentPictureId',
            userToken: _userToken,
          ),
        ));
  }

  Future<Picture> _fetchOriginalPicture() async {
    final picturesService = PicturesService();

    final originalPictureResponse =
        await picturesService.getById(id: _history.last.originalPictureId);

    if (originalPictureResponse != null &&
        originalPictureResponse.statusCode == HttpStatus.ok &&
        originalPictureResponse.body.isNotEmpty) {
      final originalPicture =
          Picture.fromJson(jsonDecode(originalPictureResponse.body));
      return originalPicture;
    }
    return null;
  }

  Future<bool> _discardChanges() async {
    setState(() {
      _isDiscardChangesLoading = true;
    });

    final picturesService = PicturesService();

    final originalPictureResponse =
        await picturesService.getById(id: _history.last.originalPictureId);

    if (originalPictureResponse != null &&
        originalPictureResponse.statusCode == HttpStatus.ok &&
        originalPictureResponse.body.isNotEmpty) {
      final originalPicture =
          Picture.fromJson(jsonDecode(originalPictureResponse.body));

      final originalPictureFileResponse = await picturesService.getFileById(
          pictureId: _history.last.originalPictureId);

      if (originalPictureFileResponse != null &&
          originalPictureFileResponse.statusCode == HttpStatus.ok &&
          originalPictureFileResponse.body.isNotEmpty) {
        final faceShapeService = FaceShapeService();

        final originalFaceShapeResponse =
            await faceShapeService.getById(id: _history.last.faceShapeId);

        if (originalFaceShapeResponse != null &&
            originalFaceShapeResponse.statusCode == HttpStatus.ok &&
            originalFaceShapeResponse.body.isNotEmpty) {
          final originalFaceShape =
              FaceShape.fromJson(jsonDecode(originalFaceShapeResponse.body));

          bool deletedAllHistoryEntries = true;

          _history
              .where((entry) =>
                  entry.originalPictureId == _history.last.originalPictureId &&
                  (entry.hairStyleId != null || entry.hairColourId != null))
              .forEach((entry) async {
            final historyService = HistoryService();

            final deleteEntryResponse =
                await historyService.delete(resourceId: entry.id);

            if (deleteEntryResponse == null ||
                deleteEntryResponse.statusCode != HttpStatus.ok) {
              deletedAllHistoryEntries = false;
              return;
            }
          });

          if (deletedAllHistoryEntries) {
            setState(() {
              _currentPictureFuture = Future.value(originalPicture);
              _currentPicture = originalPicture;
              _currentFaceShape = originalFaceShape;
              _currentHairColour = null;
              _currentHairStyle = null;
              _currentPictureFile =
                  Image.memory(originalPictureFileResponse.bodyBytes);
              _completedRoutes.clear();
              _completedRoutes.add(UploadPicture.routeName);
              _completedRoutes.add(SelectFaceShape.routeName);
              _history.removeWhere((element) =>
                  element.originalPictureId ==
                      _history.last.originalPictureId &&
                  (element.hairStyleId != null ||
                      element.hairColourId != null));
              _isDiscardChangesLoading = false;
            });

            return true;
          }
        }
      }
    }

    return false;
  }

  _onDiscardChanges() {
    if (_currentPicture == null || _currentPictureFile == null) {
      NotificationService.notify(
          scaffoldKey: scaffoldKey, message: 'No images to be discarded');
      return;
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm discard changes',
                style: TextStyle(
                    fontFamily: 'Klavika',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: Color.fromARGB(255, 0, 6, 64))),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                    'Would you like to roll back your changes to the picture that you originally uploaded?',
                    style: TextStyle(
                        fontFamily: 'Klavika',
                        fontSize: 14.0,
                        letterSpacing: 0.5,
                        color: Color.fromARGB(255, 0, 6, 64)),
                  ),
                ],
              ),
            ),
            actions: [
              !_isDiscardChangesLoading
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontFamily: 'Klavika',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: Color.fromARGB(255, 124, 62, 233)),
                      ))
                  : null,
              !_isDiscardChangesLoading
                  ? TextButton(
                      onPressed: () async {
                        if (_history.length < 2) {
                          Navigator.of(context).pop();
                          NotificationService.notify(
                              scaffoldKey: scaffoldKey,
                              message:
                                  'Original picture has not been modified yet.');
                        } else {
                          if (await _discardChanges()) {
                            Navigator.of(context).pop();
                            NotificationService.notify(
                                scaffoldKey: scaffoldKey,
                                message:
                                    'All changes were successfully discarded');
                          } else {
                            Navigator.of(context).pop();
                            NotificationService.notify(
                                scaffoldKey: scaffoldKey,
                                message:
                                    'Could not discard changes. Please upload a new picture instead.');
                          }
                        }
                      },
                      child: Text('Confirm',
                          style: TextStyle(
                            fontFamily: 'Klavika',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          )))
                  : CircularProgressIndicator()
            ].where((element) => element != null).toList(),
          );
        });
  }

  _saveResults() async {
    if (_currentPicture == null) {
      NotificationService.notify(
          scaffoldKey: scaffoldKey, message: 'Please upload a picture first.');
      return;
    }

    final picturesService = PicturesService();
    final currentPictureResponse =
        await picturesService.getFileById(pictureId: _currentPicture.id);

    if (currentPictureResponse != null &&
        currentPictureResponse.statusCode == HttpStatus.ok &&
        currentPictureResponse.body.isNotEmpty) {
      // save picture to local gallery
      final pictureFilenameWithoutExtension = _currentPicture.fileName
          .substring(
              0, _currentPicture.fileName.indexOf(RegExp(r'\.[A-Za-z]{3,}$')));

      final saveResult = await ImageGallerySaver.saveImage(
          currentPictureResponse.bodyBytes,
          quality: 100,
          name: pictureFilenameWithoutExtension);

      NotificationService.notify(
          scaffoldKey: scaffoldKey,
          message: 'Current picture saved to $saveResult');
    } else {
      NotificationService.notify(
          scaffoldKey: scaffoldKey,
          message: 'Could not retrieve picture to be saved. Please try again.');
    }
  }

  _onSaveResults() async {
    // check permissions
    final status = await Permission.storage.status;

    if (status.isGranted) {
      await _saveResults();
    } else {
      final requestStatus = await Permission.storage.request();

      if (requestStatus.isGranted) {
        await _saveResults();
      }
    }
  }

  Future<void> _onCompareResults() async {
    if (_history == null || _history.length < 2) {
      NotificationService.notify(
          scaffoldKey: scaffoldKey,
          message: 'Please make changes to the current picture first.');
      return;
    }

    if (_userToken == null) {
      NotificationService.notify(
          scaffoldKey: scaffoldKey,
          message: 'User not found. Please sign in or sign up.');
      return;
    }

    final currentOriginalPictureId = _history.last.originalPictureId;

    final picturesService = PicturesService();
    final currentOriginalPictureResponse =
        await picturesService.getById(id: currentOriginalPictureId);

    if (currentOriginalPictureResponse != null &&
        currentOriginalPictureResponse.statusCode == HttpStatus.ok &&
        currentOriginalPictureResponse.body.isNotEmpty) {
      final originalPicture =
          Picture.fromJson(jsonDecode(currentOriginalPictureResponse.body));

      final historyPictures = await Future.wait(_history
          .where((element) {
            return element.originalPictureId == currentOriginalPictureId &&
                (element.hairColourId != null || element.hairStyleId != null);
          })
          .map((e) async {
            final currentPictureResponse =
                await picturesService.getById(id: e.pictureId);

            if (currentPictureResponse != null &&
                currentPictureResponse.statusCode == HttpStatus.ok &&
                currentPictureResponse.body.isNotEmpty) {
              return Picture.fromJson(jsonDecode(currentPictureResponse.body));
            }
            NotificationService.notify(
                scaffoldKey: scaffoldKey,
                message:
                    'Could not retrieve picture: status code ${currentPictureResponse.statusCode}');
            return null;
          })
          .where((element) => element != null)
          .toList());

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HistoryView(
                  originalPicture: originalPicture,
                  historyPictures: historyPictures,
                  userToken: _userToken)));
    } else {
      NotificationService.notify(
          scaffoldKey: scaffoldKey,
          message:
              'Could not retrieve original picture. Please restart the app and upload a new picture or report this issue to the developers.');
    }
  }

  @override
  build(BuildContext context) {
    return Layout(
        scaffoldKey: scaffoldKey,
        user: _user,
        title: 'Style Me',
        header: 'Home',
        drawerItems: buildDefaultDrawerItems(context, _user, scaffoldKey),
        body: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
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
                      if (snapshot.hasData && snapshot.data.id != -1) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30.0),
                                child: GestureDetector(
                                  onTap: _onPreviewPicture,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${PicturesService.picturesUri}/file/${snapshot.data.id}',
                                    httpHeaders: {
                                      "Origin": ADMIN_PORTAL_URL,
                                      "Authorization": "Bearer $_userToken"
                                    },
                                    height: 200,
                                    progressIndicatorBuilder:
                                        (context, url, progress) {
                                      if (progress == null ||
                                          progress.progress == null) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: Icon(
                                        Icons.error,
                                        size: 128,
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Column(
                                children: [
                                  MaterialButton(
                                      onPressed: _onCompareToOriginal,
                                      height: 45.00,
                                      color: Color.fromARGB(220, 124, 62, 233),
                                      child: Text(
                                        'Compare to original',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Klavika',
                                            fontSize: 16,
                                            letterSpacing: 0.8,
                                            fontWeight: FontWeight.w700),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                  ),
                                  MaterialButton(
                                      onPressed: _onDiscardChanges,
                                      height: 45.00,
                                      color: Color.fromARGB(220, 249, 9, 17),
                                      child: Text(
                                        'Discard changes',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Klavika',
                                            fontSize: 16,
                                            letterSpacing: 0.8,
                                            fontWeight: FontWeight.w700),
                                      )),
                                ],
                              ),
                            )
                          ],
                        );
                      }
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: Column(children: [
                              Text(
                                  'A preview of your results will displayed here',
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
                      padding: const EdgeInsets.only(top: 30.0),
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
                              icon: Icon(Icons.add),
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
                              action: _latestHistoryEntry != null
                                  ? SelectFaceShape(
                                      userId: _user.id,
                                      initialFaceShapeId:
                                          _latestHistoryEntry.faceShapeId,
                                      onFaceShapeUpdated: _onFaceShapeUpdated,
                                    )
                                  : SelectFaceShape(
                                      onFaceShapeUpdated: _onFaceShapeUpdated,
                                      userId: _user.id),
                              alreadySelected: _completedRoutes
                                  .contains(SelectFaceShape.routeName),
                              enabled: _isButtonEnabled(
                                  SelectFaceShape.routeName,
                                  UploadPicture.routeName),
                            );
                          }
                          return CustomButton(
                            icon: Icon(Icons.access_time),
                            text: "Select your face shape",
                            action: SelectFaceShape(
                              userId: _user.id,
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
                                icon: _handleButtonIcon(
                                    SelectHairStyle.routeName,
                                    SelectFaceShape.routeName),
                                text: "Select a hair style",
                                action: SelectHairStyle(
                                  userToken: _userToken,
                                  onHairStyleUpdated: _onHairStyleUpdated,
                                  currentUserPicture:
                                      _originalPicture, // before: _currentPicture
                                ),
                                alreadySelected: _completedRoutes
                                    .contains(SelectHairStyle.routeName),
                                enabled: _isButtonEnabled(
                                    SelectHairStyle.routeName,
                                    SelectFaceShape.routeName));
                          }
                          return CustomButton(
                              icon: Icon(Icons.access_time),
                              text: "Select a hair style",
                              action: SelectHairStyle(
                                userToken: _userToken,
                                onHairStyleUpdated: _onHairStyleUpdated,
                                currentUserPicture:
                                    _originalPicture, // before: _currentPicture
                              ),
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
                                icon: _handleButtonIcon(
                                    SelectHairColour.routeName,
                                    SelectHairStyle.routeName),
                                text: "Colour your hair",
                                enabled: _isButtonEnabled(
                                    SelectHairColour.routeName,
                                    SelectHairStyle.routeName),
                                alreadySelected: _completedRoutes
                                    .contains(SelectHairColour.routeName),
                                action: snapshot.data.id != -1
                                    ? SelectHairColour(
                                        userToken: _userToken,
                                        currentPicture: snapshot.data,
                                        onHairColourUpdated:
                                            _onHairColourUpdated,
                                      )
                                    : SelectHairColour(
                                        userToken: _userToken,
                                        onHairColourUpdated:
                                            _onHairColourUpdated,
                                        currentPicture: snapshot.data,
                                      ));
                          }
                          return CustomButton(
                            icon: Icon(Icons.access_time),
                            text: "Select your hair colour",
                            action: SelectHairColour(
                              userToken: _userToken,
                              currentPicture: _currentPicture,
                              onHairColourUpdated: _onHairColourUpdated,
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
                            return ActionButton(
                              icon: Icon(Icons.save),
                              text: "Save your results",
                              enabled: true,
                              colour: Color.fromARGB(255, 38, 166, 154),
                              action: () async {
                                await _onSaveResults();
                              },
                            );
                          }
                          return ActionButton(
                            icon: Icon(Icons.access_time),
                            text: "Save your results",
                            enabled: false,
                            colour: Color.fromARGB(255, 38, 166, 154),
                            action: null,
                          );
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: FutureBuilder<Picture>(
                          future: _currentPictureFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ActionButton(
                                  icon: Icon(Icons.compare),
                                  text: "Compare results",
                                  colour: Color.fromARGB(255, 38, 166, 154),
                                  action: () async {
                                    await _onCompareResults();
                                  },
                                  enabled: true);
                            }
                            return CustomButton(
                              icon: Icon(Icons.access_time),
                              text: "Compare results",
                              enabled: false,
                            );
                          })),
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
