import 'dart:io';

import 'package:app/models/face_shape.dart';
import 'package:app/models/hair_colour.dart';
import 'package:app/models/hair_style.dart';
import 'package:app/models/picture.dart';
import 'package:app/models/user.dart';
import 'package:app/views/pages/select_hair_colour.dart';
import 'package:app/views/pages/select_hair_style.dart';
import 'package:app/views/pages/upload_picture.dart';
import 'package:flutter/material.dart';
import 'package:app/views/layout.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/views/pages/select_face_shape.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef OnPictureUploaded = void Function(
    {@required Picture newPicture,
    @required File pictureFile,
    FaceShape newFaceShape,
    String message});

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
  Picture _currentPicture;
  FaceShape _currentFaceShape;
  HairStyle _currentHairStyle;
  HairColour _currentHairColour;
  String _message;
  Set<String> _completedRoutes = Set();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _onPictureUploaded(
      {@required Picture newPicture,
      File pictureFile,
      FaceShape newFaceShape,
      String message}) {
    setState(() {
      _completedRoutes.add(UploadPicture.routeName);
      _currentPicture = newPicture;
      _currentPictureFile = pictureFile;
      _currentFaceShape = newFaceShape;
      _message = message ?? 'Picture successfully uploaded';
    });

    _displayMessage(message: _message);
  }

  void _onFaceShapeUpdated({@required FaceShape newFaceShape, String message}) {
    setState(() {
      _completedRoutes.add(SelectFaceShape.routeName);
      _currentFaceShape = newFaceShape;
      _message = message ?? 'Face shape updated to ${newFaceShape.shapeName}';
    });

    _displayMessage(message: _message);
  }

  void _onHairStyleUpdated({@required HairStyle newHairStyle, String message}) {
    setState(() {
      _completedRoutes.add(SelectHairStyle.routeName);
      _currentHairStyle = newHairStyle;
      _message =
          message ?? 'Hair style updated to ${newHairStyle.hairStyleName}';
    });

    _displayMessage(message: _message);
  }

  void _onHairColourUpdated(
      {@required HairColour newHairColour, String message}) {
    setState(() {
      _completedRoutes.add(SelectHairColour.routeName);
      _currentHairColour = newHairColour;
      _message =
          message ?? 'Hair colour updated to ${newHairColour.colourName}';
    });

    _displayMessage(message: _message);
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

  _displayMessage({@required String message}) {
    final snackBar = SnackBar(
      content: Text(message,
          style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontFamily: 'Klavika', fontSize: 14.0, color: Colors.white)),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          scaffoldKey.currentState.hideCurrentSnackBar();
        },
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
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
              _currentPictureFile != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: GestureDetector(
                        onTap: _onPreviewPicture,
                        child: Container(
                          height: 200.0,
                          child: Image.file(_currentPictureFile),
                        ),
                      ))
                  : null,
              Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    "Your progress",
                    style: Theme.of(context).textTheme.headline2,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: _handleButtonIcon(UploadPicture.routeName, null),
                    text: "Select or take picture",
                    alreadySelected:
                        _completedRoutes.contains(UploadPicture.routeName),
                    action:
                        UploadPicture(onPictureUploaded: _onPictureUploaded),
                    enabled: true,
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: _handleButtonIcon(
                        SelectFaceShape.routeName, UploadPicture.routeName),
                    text: "Select your face shape",
                    action: SelectFaceShape(),
                    alreadySelected:
                        _completedRoutes.contains(SelectFaceShape.routeName),
                    enabled: _isButtonEnabled(
                        SelectFaceShape.routeName, UploadPicture.routeName),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                    icon: _handleButtonIcon(
                        SelectHairStyle.routeName, SelectFaceShape.routeName),
                    text: "Select a hair style",
                    action: SelectHairStyle(),
                    alreadySelected:
                        _completedRoutes.contains(SelectHairStyle.routeName),
                    enabled: _isButtonEnabled(
                        SelectHairStyle.routeName, SelectFaceShape.routeName),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: CustomButton(
                      icon: _handleButtonIcon(SelectHairColour.routeName,
                          SelectHairStyle.routeName),
                      text: "Colour your hair",
                      enabled: _isButtonEnabled(SelectHairColour.routeName,
                          SelectHairStyle.routeName),
                      alreadySelected:
                          _completedRoutes.contains(SelectHairColour.routeName),
                      action: SelectHairColour())),
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
