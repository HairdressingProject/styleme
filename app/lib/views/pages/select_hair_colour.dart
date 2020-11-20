import 'dart:convert';
import 'dart:io';

import 'package:app/models/hair_colour.dart';
import 'package:app/models/picture.dart';
import 'package:app/services/constants.dart';
import 'package:app/services/hair_colour.dart';
import 'package:app/services/history.dart';
import 'package:app/services/notification.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/widgets/colour_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/services/pictures.dart';
import 'package:app/widgets/action_button.dart';

class SelectHairColour extends StatefulWidget {
  static final String routeName = '/selectHairColourRoute';
  final Picture currentPicture;
  final OnHairColourUpdated onHairColourUpdated;
  final String userToken;

  const SelectHairColour(
      {Key key,
      this.currentPicture,
      @required this.onHairColourUpdated,
      @required this.userToken})
      : super(key: key);

  @override
  _SelectHairColourState createState() => _SelectHairColourState();
}

class _SelectHairColourState extends State<SelectHairColour> {
  Picture _currentPicture;
  Future<List<HairColour>> _coloursFuture;
  List<ColourCard> _coloursCard;
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
  // double _l;
  Color _rgb;
  Color _selectedColour;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _saveChanges() {
    _changeHairColour();
  }

  List<ColourCard> _buildColourCards(List<HairColour> hairColours) {
    final colourCards = List.generate(hairColours.length, (index) {
      final currentColour = hairColours[index];
      return ColourCard(
          select: _selectColour,
          colourHash: currentColour.colourHash,
          colourName: currentColour.colourName,
          colourLabel: currentColour.label);
    });

    return colourCards;
  }

  Future<List<HairColour>> _fetchAllHairColours() async {
    List<HairColour> allColours = List<HairColour>();

    final hairColourService = HairColourService();

    // try to retrieve hair colours locally first
    final hairColoursMap = await hairColourService.getAllLocal();

    if (hairColoursMap.isNotEmpty) {
      allColours = List.generate(hairColoursMap.length,
          (index) => HairColour.fromJson(hairColoursMap[index]));
    } else {
      // could not retrieve hair colours locally, request them from the API instead
      final response = await hairColourService.getAll();

      if (response != null &&
          response.statusCode == 200 &&
          response.body.isNotEmpty) {
        final coloursListRaw = jsonDecode(response.body)['colours'];

        allColours = List.from(coloursListRaw)
            .map((e) => HairColour.fromJson(e))
            .toList();

        // save to local db
        allColours.forEach((element) async {
          await hairColourService.postLocal(obj: element.toJson());
        });
      }
    }

    setState(() {
      _coloursCard = _buildColourCards(allColours);
    });

    return allColours;
  }

  Future<void> _changeHairColour() async {
    if (_selectedColourCard != null) {
      setState(() {
        _isLoading = true;
      });

      final picturesService = PicturesService();
      final response = await picturesService.changeHairColourRGB(
          pictureId: _currentPicture.id,
          colourName: _selectedColourCard.colourName,
          r: _r,
          g: _g,
          b: _b);
      if (response.statusCode == HttpStatus.ok && response.body.isNotEmpty) {
        final body = jsonDecode(response.body);

        // add new history entry to local db
        final historyService = HistoryService();
        await historyService.postLocal(obj: body['history_entry']);

        // add new picture to local db
        await picturesService.postLocal(obj: body['picture']);

        widget.onHairColourUpdated(
            newHairColour: HairColour.fromJson(body['hair_colour']));

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
      _coloursCard = _coloursCard.map((c) {
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
      _r = myColor.red;
      _g = myColor.green;
      _b = myColor.blue;
      _rgb = Color.fromARGB(255, _r, _g, _b);
      _hsl = HSLColor.fromColor(_rgb);
      _alpha = _hsl.alpha;
      _h = _hsl.hue;
      _s = _hsl.saturation;
      // _l = _hsl.lightness;
      _selectedColour =
          HSLColor.fromAHSL(_alpha, _h, _s, _lightnessValue / 100).toColor();
    });
  }

  @override
  void initState() {
    super.initState();
    _currentPicture = widget.currentPicture;
    _coloursFuture = _fetchAllHairColours();
    _lightnessValue = 50.0;
    _lightnessLabel = "0%";
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
        body: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
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
                  child: _currentPicture != null
                      ? CachedNetworkImage(
                          imageUrl:
                              '${PicturesService.picturesUri}/file/${_currentPicture.id}',
                          httpHeaders: {
                            "Origin": ADMIN_PORTAL_URL,
                            "Authorization": "Bearer ${widget.userToken}"
                          },
                          progressIndicatorBuilder: (context, url, progress) {
                            if (progress == null || progress.progress == null) {
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
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.error,
                              size: 128,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.image,
                            size: 128,
                          ),
                        ),
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
                    child: FutureBuilder(
                      future: _coloursFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.0,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 5.0),
                            itemCount: _coloursCard.length,
                            itemBuilder: (context, index) {
                              return ColourCard(
                                select: _selectColour,
                                colourHash: _coloursCard[index].colourHash,
                                colourLabel: _coloursCard[index].colourLabel,
                                colourName: _coloursCard[index].colourName,
                                selected: _coloursCard[index].selected,
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Column(
                            children: [
                              const Icon(
                                Icons.error,
                                size: 128,
                              ),
                              const Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 10.0)),
                              Text(snapshot.error.toString())
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
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
