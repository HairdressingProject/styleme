import 'dart:convert';
import 'dart:io';

import 'package:app/services/model_pictures.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:app/widgets/cards_grid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/models/model_picture.dart';

class SelectHairStyle extends StatefulWidget {
  static final String routeName = '/selectHairStyleRoute';

  @override
  _SelectHairStyleState createState() => _SelectHairStyleState();
}

class _SelectHairStyleState extends State<SelectHairStyle> {
  List<SelectableCard> _hairStyles;
  SelectableCard _selectedHairStyle;
  bool _filterByLength;
  double _currentLengthFilter;
  String _currentLengthLabel;
  List<SelectableCard> _allHairStyles;

  Future<Set<ModelPicture>> _allModels;

  @override
  void initState() {
    super.initState();
    _filterByLength = false;
    _currentLengthFilter = 0;
    _currentLengthLabel = 'Short';

    _allModels = _fetchModelPictures();

    _allModels.then((m) {
      _hairStyles = _buildModelPictureCards(m);
    });
  }

  List<SelectableCard> _buildModelPictureCards(
      Set<ModelPicture> modelPictures) {
    if (modelPictures != null && modelPictures.isNotEmpty) {
      return modelPictures
          .map((e) => SelectableCard(
              type: 'modelPicture',
              modelPicture: CachedNetworkImage(
                  imageUrl:
                      '${ModelPicturesService.modelPicturesUri}/file/${e.id}',
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Icon(Icons.error)),
              id: e.id,
              // imgPath: e.filePath + e.fileName,
              label: e.hairStyleId.toString(),
              select: _selectHairStyle))
          .toList();
    }
    return [];
  }

  Future<Set<ModelPicture>> _fetchModelPictures() async {
    final response = await ModelPicturesService.getAll();
    if (response != null) {
      if (response.statusCode == HttpStatus.ok && response.body.isNotEmpty) {
        final rawModelPictures = Set.from(jsonDecode(response.body));
        final modelPictures =
            rawModelPictures.map((e) => ModelPicture.fromJson(e)).toSet();
        return modelPictures;
      }
    }
    return null;
  }

  // Future<ModelPicture> _fetchModelPictureById(modelPictureId) async {
  //   final response = await ModelPicturesService.getFileById(modelPictureId: modelPictureId);
  // }

  _selectHairStyle(SelectableCard hairStyle) {
    if (!hairStyle.selected) {
      setState(() {
        _allHairStyles = _allHairStyles.map((card) {
          if (card == hairStyle) {
            card = SelectableCard(
                imgPath: card.imgPath,
                label: card.label,
                select: _selectHairStyle,
                selected: true,
                type: card.type);
          } else {
            card = SelectableCard(
              imgPath: card.imgPath,
              label: card.label,
              select: _selectHairStyle,
              selected: false,
              type: card.type,
            );
          }
          return card;
        }).toList();

        _hairStyles = _allHairStyles
            .where(
                (hs) => _hairStyles.any((element) => element.label == hs.label))
            .toList();
        _selectedHairStyle = hairStyle;
      });
    }
  }

  _saveChanges() {
    // TODO: save changes with _selectedHairStyle
    print('Selected face shape: ${_selectedHairStyle.label}');
  }

  void _toggleFilterByLength(bool selected) {
    setState(() {
      _filterByLength = selected;
      if (selected) {
        _hairStyles = _allHairStyles
            .where((hs) =>
                hs.type.toLowerCase() == _currentLengthLabel.toLowerCase())
            .toList();
      } else {
        _hairStyles = _allHairStyles;
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
        _hairStyles = _allHairStyles
            .where((hs) =>
                hs.type.toLowerCase() == _currentLengthLabel.toLowerCase())
            .toList();
      }
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
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
                FutureBuilder(
                    future: _allModels,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Container(
                          height: viewportConstraints.maxHeight - 320.0,
                          child: CardsGrid(
                            cards: _hairStyles,
                          ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
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
            )),
          ));
        }));
  }
}
