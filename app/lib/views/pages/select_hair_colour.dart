import 'package:app/models/hair_colour.dart';
import 'package:app/widgets/cards_grid.dart';
import 'package:app/widgets/colour_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectHairColour extends StatefulWidget {
  static final String routeName = '/selectHairColourRoute';

  @override
  _SelectHairColourState createState() => _SelectHairColourState();
}

class _SelectHairColourState extends State<SelectHairColour> {
  List<ColourCard> _colours;
  ColourCard _selectedColourCard;

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
    // TODO: implement initState
    super.initState();
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
          return Scrollbar(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                      minWidth: viewportConstraints.maxWidth),
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
                      Expanded(
                        child: GridView.count(
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            crossAxisCount: 3,
                            children: _colours),
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
                  )));
        }));
  }
}
