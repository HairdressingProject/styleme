import 'dart:convert';
import 'dart:io';

import 'package:app/models/hair_length.dart';
import 'package:app/models/hair_style.dart';
import 'package:app/models/history.dart';
import 'package:app/models/picture.dart';
import 'package:app/services/constants.dart';
import 'package:app/services/hair_style.dart';
import 'package:app/services/model_pictures.dart';
import 'package:app/services/notification.dart';
import 'package:app/services/pictures.dart';
import 'package:app/views/pages/home.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:app/widgets/cards_grid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/models/model_picture.dart';

class SelectHairStyle extends StatefulWidget {
  static final String routeName = '/selectHairStyleRoute';
  final String userToken;
  final List<HairStyle> allHairStyles;
  final List<ModelPicture> allModelPictures;
  final List<HairLength> allHairLengths;
  final Picture currentUserPicture;
  final OnHairStyleUpdated onHairStyleUpdated;

  const SelectHairStyle(
      {Key key,
      @required this.userToken,
      @required this.allHairStyles,
      @required this.allModelPictures,
      @required this.allHairLengths,
      @required this.onHairStyleUpdated,
      @required this.currentUserPicture})
      : super(key: key);

  @override
  _SelectHairStyleState createState() => _SelectHairStyleState();
}

class _SelectHairStyleState extends State<SelectHairStyle> {
  bool _isLoading = false;
  List<HairStyle> _allHairStyles;
  List<SelectableCard> _allHairStyleCards;
  List<SelectableCard> _hairStyleCards;
  SelectableCard _selectedHairStyle;
  bool _filterByLength;
  double _currentLengthFilter;
  String _currentLengthLabel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _filterByLength = false;
    _currentLengthFilter = 0.0;
    _currentLengthLabel = widget.allHairLengths[0].label;
    _allHairStyles = widget.allHairStyles;
    _allHairStyleCards = _buildModelPictureCards(widget.allModelPictures);
    _hairStyleCards = _allHairStyleCards;
  }

  List<SelectableCard> _buildModelPictureCards(
      List<ModelPicture> modelPictures) {
    if (modelPictures != null &&
        modelPictures.isNotEmpty &&
        _allHairStyles != null &&
        _allHairStyles.isNotEmpty) {
      return modelPictures
          .map((e) => SelectableCard(
              type: 'modelPicture',
              modelPicture: e,
              modelPictureWidget: widget.userToken != null
                  ? CachedNetworkImage(
                      imageUrl:
                          '${ModelPicturesService.modelPicturesUri}/file/${e.id}',
                      placeholder: (context, url) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      httpHeaders: {
                        "Origin": ADMIN_PORTAL_URL,
                        "Authorization": "Bearer ${widget.userToken}"
                      },
                    )
                  : Icon(Icons.image),
              id: e.id,
              label: _allHairStyles
                  .firstWhere((element) => element.id == e.hairStyleId)
                  .label,
              select: _selectHairStyle))
          .toList();
    }
    return List<SelectableCard>();
  }

  _selectHairStyle(SelectableCard hairStyle) {
    if (!hairStyle.selected) {
      setState(() {
        _allHairStyleCards = _allHairStyleCards.map((card) {
          if (card.id == hairStyle.id) {
            card = SelectableCard(
                id: card.id,
                label: card.label,
                select: _selectHairStyle,
                modelPicture: card.modelPicture,
                modelPictureWidget: Image.network(
                  '${ModelPicturesService.modelPicturesUri}/file/${card.id}',
                  headers: {
                    "Origin": ADMIN_PORTAL_URL,
                    "Authorization": "Bearer ${widget.userToken}"
                  },
                ),
                selected: true,
                type: card.type);
          } else {
            card = SelectableCard(
              id: card.id,
              label: card.label,
              select: _selectHairStyle,
              modelPicture: card.modelPicture,
              modelPictureWidget: Image.network(
                '${ModelPicturesService.modelPicturesUri}/file/${card.id}',
                headers: {
                  "Origin": ADMIN_PORTAL_URL,
                  "Authorization": "Bearer ${widget.userToken}"
                },
              ),
              selected: false,
              type: card.type,
            );
          }
          return card;
        }).toList();

        _hairStyleCards = _allHairStyleCards
            .where(
                (hs) => _hairStyleCards.any((element) => element.id == hs.id))
            .toList();

        _selectedHairStyle = hairStyle;
      });
    }
  }

  Future<HairStyle> _getHairStyleFromHistory(
      {@required int hairStyleId}) async {
    final historyHairStyleId = hairStyleId;
    final hairStyleResponse =
        await HairStyleService.getById(id: historyHairStyleId);

    if (hairStyleResponse != null &&
        hairStyleResponse.statusCode == HttpStatus.ok &&
        hairStyleResponse.body.isNotEmpty) {
      final hairStyle = HairStyle.fromJson(jsonDecode(hairStyleResponse.body));

      return hairStyle;
    }
    return null;
  }

  _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    final hairStyleChangeResponse = await PicturesService.changeHairStyle(
        userPictureId: widget.currentUserPicture.id,
        modelPictureId: _selectedHairStyle.id);

    if (hairStyleChangeResponse != null &&
        hairStyleChangeResponse.statusCode == HttpStatus.ok &&
        hairStyleChangeResponse.body.isNotEmpty) {
      final History historyEntry =
          History.fromJson(jsonDecode(hairStyleChangeResponse.body));

      final hairStyle =
          await _getHairStyleFromHistory(hairStyleId: historyEntry.hairStyleId);

      widget.onHairStyleUpdated(
          newHairStyle: _allHairStyles.firstWhere(
        (element) => element.id == _selectedHairStyle.id,
        orElse: () => hairStyle,
      ));

      Navigator.pop(context);
    } else {
      NotificationService.notify(
          scaffoldKey: _scaffoldKey,
          message:
              "Failed to change hair style. Please try again or use a different picture.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleFilterByLength(bool selected) {
    setState(() {
      _filterByLength = selected;
      if (selected) {
        final hairLengthFilterId = widget.allHairLengths
            .firstWhere((element) => element.label == _currentLengthLabel)
            .id;

        _hairStyleCards = _allHairStyleCards
            .where((hs) => hs.modelPicture.hairLengthId == hairLengthFilterId)
            .toList();
      } else {
        _hairStyleCards = _allHairStyleCards;
      }
    });
  }

  _setCurrentLengthFilter(double value) {
    setState(() {
      _currentLengthFilter = value;
      if (value < 1.0) {
        _currentLengthLabel = 'Short';
      } else if (value >= 1.0 && value < 2.0) {
        _currentLengthLabel = 'Medium';
      } else {
        _currentLengthLabel = 'Long';
      }

      if (_filterByLength) {
        final hairLengthFilterId = widget.allHairLengths
            .firstWhere((element) => element.label == _currentLengthLabel)
            .id;

        _hairStyleCards = _allHairStyleCards
            .where((hs) => hs.modelPicture.hairLengthId == hairLengthFilterId)
            .toList();
      }
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Select a hair style',
            style: TextStyle(fontFamily: 'Klavika'),
          ),
        ),
        body: LayoutBuilder(builder: (context, viewportConstraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Scrollbar(
                child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                SvgPicture.asset(
                  'assets/icons/select_hair_style_top.svg',
                  semanticsLabel: 'Select hair style',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Text(
                  'Select a hair style',
                  style: Theme.of(context).textTheme.headline1,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Filter by length',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontFamily: 'Klavika',
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                    ),
                    Checkbox(
                        value: _filterByLength,
                        onChanged: _toggleFilterByLength)
                  ],
                ),
                const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Short',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontFamily: 'Klavika', fontSize: 18.0)),
                    Slider(
                      onChanged: _setCurrentLengthFilter,
                      value: _currentLengthFilter,
                      min: 0,
                      max: 2,
                      divisions: 2,
                      label: _currentLengthLabel,
                    ),
                    Text('Long',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontFamily: 'Klavika', fontSize: 18.0)),
                  ],
                ),
                const Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0)),
                Container(
                    height: viewportConstraints.maxHeight - 320.0,
                    child: CardsGrid(
                      cards: _hairStyleCards,
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                Container(
                  width: 200.0,
                  height: 40.0,
                  child: !_isLoading
                      ? MaterialButton(
                          disabledColor: Colors.grey[600],
                          disabledTextColor: Colors.white,
                          onPressed: () async {
                            await _saveChanges();
                          },
                          color: Color.fromARGB(255, 74, 169, 242),
                          minWidth: double.infinity,
                          child: Text(
                            'Save changes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.white),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ],
            )),
          ));
        }));
  }
}
