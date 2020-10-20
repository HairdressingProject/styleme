import 'package:app/models/hair_style.dart';
import 'package:app/services/model_pictures.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:app/widgets/cards_grid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/models/model_picture.dart';

class SelectHairStyle extends StatefulWidget {
  static final String routeName = '/selectHairStyleRoute';
  final List<HairStyle> allHairStyles;
  final List<ModelPicture> allModelPictures;

  const SelectHairStyle(
      {Key key, @required this.allHairStyles, @required this.allModelPictures})
      : super(key: key);

  @override
  _SelectHairStyleState createState() => _SelectHairStyleState();
}

class _SelectHairStyleState extends State<SelectHairStyle> {
  List<HairStyle> _allHairStyles;
  List<SelectableCard> _allHairStyleCards;
  List<SelectableCard> _hairStyleCards;
  SelectableCard _selectedHairStyle;
  bool _filterByLength;
  double _currentLengthFilter;
  String _currentLengthLabel;

  @override
  void initState() {
    super.initState();
    _filterByLength = false;
    _currentLengthFilter = 0;
    _allHairStyles = widget.allHairStyles;
    _currentLengthLabel = _allHairStyles[0].label;
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
              modelPicture: CachedNetworkImage(
                  imageUrl:
                      '${ModelPicturesService.modelPicturesUri}/file/${e.id}',
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Icon(Icons.error)),
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
    print('Selected hair style card: ${hairStyle.label} (ID = ${hairStyle.id}');

    if (!hairStyle.selected) {
      setState(() {
        _allHairStyleCards = _allHairStyleCards.map((card) {
          if (card.id == hairStyle.id) {
            card = SelectableCard(
                id: card.id,
                imgPath: card.imgPath,
                label: card.label,
                select: _selectHairStyle,
                selected: true,
                type: card.type);
          } else {
            card = SelectableCard(
              id: card.id,
              imgPath: card.imgPath,
              label: card.label,
              select: _selectHairStyle,
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

  _saveChanges() {
    // TODO: save changes with _selectedHairStyle
    print(
        'Selected hair style: ${_selectedHairStyle.label} (ID = ${_selectedHairStyle.id}');
  }

  void _toggleFilterByLength(bool selected) {
    setState(() {
      _filterByLength = selected;
      if (selected) {
        _hairStyleCards = _allHairStyleCards
            .where((hs) => hs.label == _currentLengthLabel.toLowerCase())
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
        _hairStyleCards = _allHairStyleCards
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
