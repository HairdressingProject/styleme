import 'dart:convert';
import 'dart:io';

import 'package:app/models/hair_colour.dart';
import 'package:app/models/picture.dart';
import 'package:app/models/history.dart';
import 'package:app/services/notification.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/widgets/colour_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/services/pictures.dart';
import 'package:app/widgets/action_button.dart';

class SelectHairColour extends StatefulWidget {
  static final String routeName = '/selectHairColourRoute';
  final Image currentPictureFile;
  final Picture currentPicture;
  final OnHairColourUpdated onHairColourUpdated;
  final HairColour currentHairColour;

  const SelectHairColour(
      {Key key,
      @required this.currentPictureFile,
      @required this.currentPicture,
      @required this.onHairColourUpdated,
      @required this.currentHairColour})
      : super(key: key);

  @override
  _SelectHairColourState createState() => _SelectHairColourState();
}

class _SelectHairColourState extends State<SelectHairColour> {
  HairColour _currentHairColour;
  Image _currentPictureFile;
  Picture _currentPicture;
  List<ColourCard> _colours;
  ColourCard _selectedColourCard;
  double _lightnessValue;
  String _lightnessLabel;
  bool _isLoading = false;
  int _r;
  int _b;
  int _g;
  HSLColor _hsl;
  double _alpha;
  double _h;
  double _s;
  double _l;
  Color _rgb;
  Color _selectedColour;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _saveChanges() {
    // TODO: Save _selectedColour
    print('Cahnging hair colour to ${_selectedColourCard.colourLabel}');
    _changeHairColour();
  }

  Future<void> _changeHairColour() async {
    if (_selectedColourCard != null) {
      setState(() {
        _isLoading = true;
      });
      //final response = await PicturesService.changeHairColour(pictureId: 60, colourName: _selectedColourCard.colourName);
      print("_currentPicture.id");
      print(_currentPicture.id);
      final response = await PicturesService.changeHairColourRGB(
          pictureId: _currentPicture.id,
          colourName: _selectedColourCard.colourName,
          r: _r,
          g: _g,
          b: _b);
      if (response.statusCode == HttpStatus.ok &&
          response.body.isNotEmpty) {

        print(response.body);
        
        final History historyEntry =
          History.fromJson(jsonDecode(response.body));

        final HairColour hairColourEntry =
          HairColour.fromJson(jsonDecode(response.body)['hair_colour']);

        print(hairColourEntry);

        print('_currentHairColour');
        print(_currentHairColour);

        print('_selectedColourCard.colourName');
        print(_selectedColourCard.colourName);        

        widget.onHairColourUpdated(
          newHairColour: _currentHairColour
        );
          

        print(response.request);
        print(response.request.headers);
        print('Response from API:');
        print('${response.body}');
        print("Selected colour: ");
        print(_selectedColour.red);
        print(_selectedColour.blue);
        print(_selectedColour.green);

        // ToDo: Improve error messages
        // if (response.statusCode == 200) {
        //   NotificationService.notify(
        //       scaffoldKey: _scaffoldKey,
        //       message: 'Hair colour successfully applied');
        // } else {
        //   NotificationService.notify(
        //       scaffoldKey: _scaffoldKey,
        //       message: 'Hair colour already applied');
        // }
        Navigator.pop(context);
      } else {
        NotificationService.notify(
            scaffoldKey: _scaffoldKey,
            message: 'Could not apply hair colour. Please try again.');
      }
    } else {
      NotificationService.notify(
          scaffoldKey: _scaffoldKey, message: 'Please select a hair colour');
    }
    setState(() {
      _isLoading = false;
    });
  }

  _selectColour(ColourCard card) {
    setState(() {
      _colours = _colours.map((c) {
        if (c.colourHash == card.colourHash) {
          c = ColourCard(
            select: _selectColour,
            colourHash: c.colourHash,
            colourLabel: c.colourLabel,
            colourName: c.colourName,
            selected: true,
          );
        } else {
          c = ColourCard(
            select: _selectColour,
            colourHash: c.colourHash,
            colourLabel: c.colourLabel,
            colourName: c.colourName,
            selected: false,
          );
        }
        return c;
      }).toList();

      _selectedColourCard = card;
      Color myColor = HexColor(_selectedColourCard.colourHash);
      print(myColor);
      _r = myColor.red;
      _g = myColor.green;
      _b = myColor.blue;
      _rgb = Color.fromARGB(255, _r, _g, _b);
      _hsl = HSLColor.fromColor(_rgb);
      _alpha = _hsl.alpha;
      _h = _hsl.hue;
      _s = _hsl.saturation;
      _l = _hsl.lightness;
      _selectedColour =
          HSLColor.fromAHSL(_alpha, _h, _s, _lightnessValue / 100).toColor();
    });
  }

  @override
  void initState() {
    super.initState();
    _currentPicture = widget.currentPicture;
    _currentPictureFile = widget.currentPictureFile;
    _currentHairColour = widget.currentHairColour;
    _lightnessValue = 50.0;
    _lightnessLabel = "0%";
    _colours = [
      ColourCard(
          select: _selectColour,
          colourHash: '#F9E726',
          colourName: 'sunny_yellow',
          colourLabel: 'Sunny yellow'),
      ColourCard(
          select: _selectColour,
          colourHash: '#EC6126',
          colourName: 'juicy_orange',
          colourLabel: 'Juicy orange'),
      ColourCard(
          select: _selectColour,
          colourHash: '#B80C44',
          colourName: 'fiery_red',
          colourLabel: 'Fiery red'),
      ColourCard(
          select: _selectColour,
          colourHash: '#CF34B1',
          colourName: 'hot_pink',
          colourLabel: 'Hot pink'),
      ColourCard(
          select: _selectColour,
          colourHash: '#402D87',
          colourName: 'mysterious_violet',
          colourLabel: 'Mysterious violet'),
      ColourCard(
          select: _selectColour,
          colourHash: '#013C7A',
          colourName: 'ocean_blue',
          colourLabel: 'Ocean blue'),
      ColourCard(
          select: _selectColour,
          colourHash: '#255638',
          colourName: 'tropical_green',
          colourLabel: 'Tropical green'),
      ColourCard(
          select: _selectColour,
          colourHash: '#27221C',
          colourName: 'jet_black',
          colourLabel: 'Jet black')
    ];
  }

  _onChangeLightness(double value) {
    setState(() {
      _lightnessValue = value;
      _lightnessLabel = '${_lightnessValue.toStringAsFixed(1)}%';

      _selectedColour =
          HSLColor.fromAHSL(_alpha, _h, _s, _lightnessValue / 100).toColor();

      _r = _selectedColour.red;
      _b = _selectedColour.blue;
      _g = _selectedColour.green;
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Select a hair colour',
            style: TextStyle(fontFamily: 'Klavika'),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                SvgPicture.asset(
                  'assets/icons/select_hair_colour_top.svg',
                  semanticsLabel: 'Select hair colour',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Text(
                  'Colour your hair',
                  style: Theme.of(context).textTheme.headline1,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Container(
                  height: 150.0,
                  child: _currentPictureFile,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                Text(
                  'Colour swatch',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(fontFamily: 'Klavika'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                Container(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 5.0),
                      itemCount: _colours.length,
                      itemBuilder: (context, index) {
                        return ColourCard(
                          select: _selectColour,
                          colourHash: _colours[index].colourHash,
                          colourLabel: _colours[index].colourLabel,
                          colourName: _colours[index].colourName,
                          selected: _colours[index].selected,
                        );
                      },
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Lightness',
                        style: Theme.of(context).textTheme.headline2.copyWith(
                              fontFamily: 'Klavika',
                            )),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '0.0%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontFamily: 'Klavika'),
                              ),
                              Slider(
                                value: _lightnessValue,
                                label: _lightnessLabel,
                                onChanged: _onChangeLightness,
                                divisions: 100,
                                min: 0.0,
                                max: 100.0,
                              ),
                              Text(
                                '100.0%',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontFamily: 'Klavika'),
                              ),
                            ]))
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Preview',
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(fontFamily: 'Klavika')),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: 100.0,
                        height: 100.0,
                        color: _selectedColourCard != null
                            ? HSLColor.fromAHSL(
                                    _alpha, _h, _s, _lightnessValue / 100)
                                .toColor()
                            : HSLColor.fromColor(
                                    Theme.of(context).backgroundColor)
                                .toColor())
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ActionButton(
                          text: 'Save changes',
                          action: _saveChanges,
                          colour: Color.fromARGB(255, 74, 169, 242)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                ),
              ],
            ),
          ),
        ));
  }
}
