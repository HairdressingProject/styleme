import 'dart:convert';
import 'dart:io';

import 'package:app/services/model_pictures.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:app/widgets/cards_grid.dart';
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
      print(m);
    });

    _allHairStyles = [
      // short
      SelectableCard(
        imgPath: 'assets/hair_styles/short_french_bob.jpg',
        label: 'Short french bob',
        select: _selectHairStyle,
        type: 'short',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/short_afro_mohawk.jpg',
        label: 'Short afro mohawk',
        select: _selectHairStyle,
        type: 'short',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/short_fringe.jpg',
        label: 'Short fringe',
        select: _selectHairStyle,
        type: 'short',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/short_box_braids.jpg',
        label: 'Short box braids',
        select: _selectHairStyle,
        type: 'short',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/short_side_swept_bangs.jpg',
        label: 'Short side bangs',
        select: _selectHairStyle,
        type: 'short',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/short_edgy_undercut.jpg',
        label: 'Short edgy undercut',
        select: _selectHairStyle,
        type: 'short',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/short_soft_curls.jpg',
        label: 'Short soft curls',
        select: _selectHairStyle,
        type: 'short',
      ),
      // medium
      SelectableCard(
        imgPath: 'assets/hair_styles/medium_angled_bob.jpg',
        label: 'Medium angled bob',
        select: _selectHairStyle,
        type: 'medium',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/medium_ashy_ombre.jpg',
        label: 'Medium ashy ombre',
        select: _selectHairStyle,
        type: 'medium',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/medium_asymmetrical_bob.jpg',
        label: 'Medium asymm. bob',
        select: _selectHairStyle,
        type: 'medium',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/medium_curly_bangs.jpg',
        label: 'Medium curly bangs',
        select: _selectHairStyle,
        type: 'medium',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/medium_curly_bob.jpg',
        label: 'Medium curly bob',
        select: _selectHairStyle,
        type: 'medium',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/medium_side_swept_braids.jpg',
        label: 'Medium side braids',
        select: _selectHairStyle,
        type: 'medium',
      ),
      // long
      SelectableCard(
        imgPath: 'assets/hair_styles/long_beach_curls.jpg',
        label: 'Long beach curls',
        select: _selectHairStyle,
        type: 'long',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/long_braided_pigtails.jpg',
        label: 'Long braided pigtails',
        select: _selectHairStyle,
        type: 'long',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/long_curls.jpg',
        label: 'Long curls',
        select: _selectHairStyle,
        type: 'long',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/long_curly_middle_part.jpg',
        label: 'Long curls m. part',
        select: _selectHairStyle,
        type: 'long',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/long_shaggy_layers.jpg',
        label: 'Long shaggy layers',
        select: _selectHairStyle,
        type: 'long',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/long_sleek_ponytail.jpg',
        label: 'Long sleek ponytail',
        select: _selectHairStyle,
        type: 'long',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/long_smooth_layers_and_bangs.jpg',
        label: 'Long layers and bangs',
        select: _selectHairStyle,
        type: 'long',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/long_top_knot.jpg',
        label: 'Long top knot',
        select: _selectHairStyle,
        type: 'long',
      ),
      SelectableCard(
        imgPath: 'assets/hair_styles/long_voluminous_waves.jpg',
        label: 'Long vol. waves',
        select: _selectHairStyle,
        type: 'long',
      ),
    ];

    _hairStyles = _allHairStyles;
    _selectedHairStyle = _hairStyles[0];
  }

  Future<Set<ModelPicture>> _fetchModelPictures() async {
    final modelPictureResponse = await ModelPicturesService.getAll();
    if (modelPictureResponse.statusCode == HttpStatus.ok && modelPictureResponse.body.isNotEmpty) {
      final rawModelPictures = Set.from(jsonDecode(modelPictureResponse.body));
      return rawModelPictures.map((e) => ModelPicture.fromJson(e)).toSet();
    }
    return null;

  }

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
                Container(
                  height: viewportConstraints.maxHeight - 320.0,
                  child: CardsGrid(
                    cards: _hairStyles,
                  ),
                ),
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
