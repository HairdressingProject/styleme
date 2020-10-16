import 'package:app/models/hair_colour.dart';
import 'package:app/widgets/cards_grid.dart';
import 'package:app/widgets/colour_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class SelectHairColour extends StatefulWidget {
  static final String routeName = '/selectHairColourRoute';

  @override
  _SelectHairColourState createState() => _SelectHairColourState();
}

class _SelectHairColourState extends State<SelectHairColour> {
  List<ColourCard> _colours;
  ColourCard _selectedColourCard;
  double _lightnessValue;
  String _lightnessLabel;
  final ScrollController _scrollController = ScrollController();

  _saveChanges() {
    // TODO: Save _selectedColour
  }

  _selectColour(ColourCard card) {
    setState(() {
      _colours = _colours.map((c) {
        if (c.colourHash == card.colourHash) {
          c = ColourCard(
            select: _selectColour,
            colourHash: c.colourHash,
            colourLabel: c.colourLabel,
            selected: true,
          );
        } else {
          c = ColourCard(
            select: _selectColour,
            colourHash: c.colourHash,
            colourLabel: c.colourLabel,
            selected: false,
          );
        }
        return c;
      }).toList();

      _selectedColourCard = card;
    });
  }

  @override
  void initState() {
    super.initState();
    _lightnessValue = 0.0;
    _lightnessLabel = "0%";
    _colours = [
      ColourCard(
          select: _selectColour,
          colourHash: '#F9E726',
          colourLabel: 'Sunny yellow'),
      ColourCard(
          select: _selectColour,
          colourHash: '#EC6126',
          colourLabel: 'Juicy orange'),
      ColourCard(
          select: _selectColour,
          colourHash: '#B80C44',
          colourLabel: 'Fiery red'),
      ColourCard(
          select: _selectColour,
          colourHash: '#CF34B1',
          colourLabel: 'Hot pink'),
      ColourCard(
          select: _selectColour,
          colourHash: '#402D87',
          colourLabel: 'Mysterious violet'),
      ColourCard(
          select: _selectColour,
          colourHash: '#013C7A',
          colourLabel: 'Ocean blue'),
      ColourCard(
          select: _selectColour,
          colourHash: '#255638',
          colourLabel: 'Tropical green'),
      ColourCard(
          select: _selectColour,
          colourHash: '#27221C',
          colourLabel: 'Jet black')
    ];
  }

  _onChangeLightness(double value) {
    setState(() {
      _lightnessValue = value;
      _lightnessLabel = '${_lightnessValue.toStringAsFixed(1)}%';
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
                Image.asset(
                  'assets/hair_styles/long_shaggy_layers.jpg',
                  height: 150.0,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
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
                            ? Color.alphaBlend(
                                HexColor(_selectedColourCard.colourHash),
                                Color.fromARGB(0, 255, 255, 255),
                              )
                            : Theme.of(context).backgroundColor)
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
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
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                ),
              ],
            ),
          ),
        ));
  }
}
