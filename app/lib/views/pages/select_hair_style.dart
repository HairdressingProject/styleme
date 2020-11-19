import 'dart:convert';
import 'dart:io';

import 'package:app/models/hair_length.dart';
import 'package:app/models/hair_style.dart';
import 'package:app/models/history.dart';
import 'package:app/models/picture.dart';
import 'package:app/services/constants.dart';
import 'package:app/services/hair_length.dart';
import 'package:app/services/hair_style.dart';
import 'package:app/services/history.dart';
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
  // final List<HairStyle> allHairStyles;
  // final List<ModelPicture> allModelPictures;
  // final List<HairLength> allHairLengths;
  final Picture currentUserPicture;
  final OnHairStyleUpdated onHairStyleUpdated;

  const SelectHairStyle(
      {Key key,
      @required this.userToken,
      // @required this.allHairStyles,
      // @required this.allModelPictures,
      // @required this.allHairLengths,
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
  Future<List<ModelPicture>> _modelPicturesFuture;
  List<ModelPicture> _allModelPictures;
  List<HairLength> _allHairLengths;
  bool _filterByLength;
  double _currentLengthFilter;
  String _currentLengthLabel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _filterByLength = true;
    _currentLengthFilter = 0.0;
    _modelPicturesFuture = _fetchAllModelPictures();
  }

  Future<List<HairStyle>> _fetchAllHairStyles() async {
    final hairStyleService = HairStyleService();
    List<HairStyle> hairStyles = List<HairStyle>();

    // check locally stored hair styles
    final hairStylesMap = await hairStyleService.getAllLocal();

    if (hairStylesMap.isNotEmpty) {
      hairStyles = hairStylesMap.map((e) => HairStyle.fromJson(e)).toList();
    } else {
      final allHairStylesResponse = await hairStyleService.getAll();

      if (allHairStylesResponse != null &&
          allHairStylesResponse.statusCode == HttpStatus.ok &&
          allHairStylesResponse.body.isNotEmpty) {
        final rawHairStyles =
            jsonDecode(allHairStylesResponse.body)['hair_styles'];
        final rawHairStylesList = List.from(rawHairStyles);

        if (rawHairStylesList.isNotEmpty) {
          rawHairStylesList.forEach((element) async {
            final current = HairStyle.fromJson(element);
            await hairStyleService.postLocal(obj: current.toJson());
          });

          hairStyles =
              rawHairStylesList.map((e) => HairStyle.fromJson(e)).toList();
        }
      }
    }

    return hairStyles;
  }

  Future<List<HairLength>> _fetchAllHairLengths() async {
    final hairLengthService = HairLengthService();
    List<HairLength> hairLengths = List<HairLength>();

    // check locally stored hair lengths
    final hairLengthsMap = await hairLengthService.getAllLocal();

    if (hairLengthsMap.isNotEmpty) {
      hairLengths = hairLengthsMap.map((e) => HairLength.fromJson(e)).toList();
    } else {
      // hair lengths not found locally, request from API
      final allHairLengthsResponse = await hairLengthService.getAll();

      if (allHairLengthsResponse != null &&
          allHairLengthsResponse.statusCode == HttpStatus.ok &&
          allHairLengthsResponse.body.isNotEmpty) {
        final rawHairLengths =
            jsonDecode(allHairLengthsResponse.body)['hair_lengths'];
        final rawHairLengthsList = List.from(rawHairLengths);
        if (rawHairLengthsList.isNotEmpty) {
          // save hair lengths to local db
          rawHairLengthsList.forEach((element) async {
            final current = HairLength.fromJson(element);
            await hairLengthService.postLocal(obj: current.toJson());
          });
          hairLengths =
              rawHairLengthsList.map((e) => HairLength.fromJson(e)).toList();
        }
      }
    }

    return hairLengths;
  }

  Future<List<ModelPicture>> _fetchAllModelPictures() async {
    final allHairLengths = await _fetchAllHairLengths();
    final allHairStyles = await _fetchAllHairStyles();

    final modelPicturesService = ModelPicturesService();
    List<ModelPicture> modelPictures = List<ModelPicture>();

    // try to fetch model pictures locally
    final modelPicturesMap = await modelPicturesService.getAllLocal();

    if (modelPicturesMap.isNotEmpty) {
      modelPictures =
          modelPicturesMap.map((e) => ModelPicture.fromJson(e)).toList();
    } else {
      final allModelPicturesResponse = await modelPicturesService.getAll();

      if (allModelPicturesResponse != null &&
          allModelPicturesResponse.statusCode == HttpStatus.ok &&
          allModelPicturesResponse.body.isNotEmpty) {
        final rawModelPictures = jsonDecode(allModelPicturesResponse.body);
        final rawModelPicturesList = List.from(rawModelPictures);

        if (rawModelPicturesList.isNotEmpty) {
          rawModelPicturesList.forEach((element) async {
            final current = ModelPicture.fromJson(element);
            await modelPicturesService.postLocal(obj: current.toJson());
          });

          modelPictures = rawModelPicturesList
              .map((e) => ModelPicture.fromJson(e))
              .toList();
        }
      }
    }

    setState(() {
      _allHairStyles = allHairStyles;
      _allHairLengths = allHairLengths;
      _allModelPictures = modelPictures;
      _allHairStyleCards = _buildModelPictureCards(_allModelPictures);
      _currentLengthLabel = _allHairLengths[0].label;
      _hairStyleCards = _buildModelPictureCards(
          _allModelPictures.where((mp) => mp.hairLengthId == 1).toList());
    });

    return modelPictures;
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
                      httpHeaders: {
                        "Origin": ADMIN_PORTAL_URL,
                        "Authorization": "Bearer ${widget.userToken}"
                      },
                    )
                  : Icon(Icons.image, size: 64),
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
                modelPictureWidget: CachedNetworkImage(
                  imageUrl:
                      '${ModelPicturesService.modelPicturesUri}/file/${card.id}',
                  httpHeaders: {
                    "Origin": ADMIN_PORTAL_URL,
                    "Authorization": "Bearer ${widget.userToken}"
                  },
                  progressIndicatorBuilder: (context, url, progress) {
                    if (progress != null && progress.progress != null) {
                      return Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
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
              modelPictureWidget: CachedNetworkImage(
                imageUrl:
                    '${ModelPicturesService.modelPicturesUri}/file/${card.id}',
                httpHeaders: {
                  "Origin": ADMIN_PORTAL_URL,
                  "Authorization": "Bearer ${widget.userToken}"
                },
                progressIndicatorBuilder: (context, url, progress) {
                  if (progress != null && progress.progress != null) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              selected: false,
              type: card.type,
            );
          }
          return card;
        }).toList();

        setState(() {
          _hairStyleCards = _allHairStyleCards
              .where(
                  (hs) => _hairStyleCards.any((element) => element.id == hs.id))
              .toList();

          _selectedHairStyle = hairStyle;
        });
      });
    }
  }

  _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    final picturesService = PicturesService();
    final hairStyleChangeResponse = await picturesService.changeHairStyle(
        userPictureId: widget.currentUserPicture.id,
        modelPictureId: _selectedHairStyle.id);

    if (hairStyleChangeResponse != null &&
        hairStyleChangeResponse.statusCode == HttpStatus.ok &&
        hairStyleChangeResponse.body.isNotEmpty) {
      final body = jsonDecode(hairStyleChangeResponse.body);

      final historyEntry = History.fromJson(body['history_entry']);
      final newHairStyle = HairStyle.fromJson(body['hair_style']);
      final newPicture = Picture.fromJson(body['current_picture']);

      // save new history entry to local db
      final historyService = HistoryService();
      await historyService.postLocal(obj: historyEntry.toJson());

      // save new picture to local db
      await picturesService.postLocal(obj: newPicture.toJson());

      widget.onHairStyleUpdated(
          newHairStyle: _allHairStyles.firstWhere(
        (element) => element.id == _selectedHairStyle.id,
        orElse: () => newHairStyle,
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
        final hairLengthFilterId = _allHairLengths
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
        final hairLengthFilterId = _allHairLengths
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
                child: FutureBuilder(
              future: _modelPicturesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
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
                                  .copyWith(
                                      fontFamily: 'Klavika', fontSize: 18.0)),
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
                                  .copyWith(
                                      fontFamily: 'Klavika', fontSize: 18.0)),
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
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(Icons.error, size: 128),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Text(snapshot.error.toString())
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
          ));
        }));
  }
}
