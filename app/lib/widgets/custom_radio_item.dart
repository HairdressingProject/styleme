import 'package:flutter/material.dart';
import 'package:app/widgets/face_card.dart';

class CustomRadio extends StatefulWidget {
  @override
  createState() {
    return new CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  List<RadioModel> sampleData = new List<RadioModel>();
  // List<FaceCard> sampleData = new List<FaceCard>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sampleData.add(new RadioModel(false, FaceCard(text: 'Round', path: 'assets/icons/round.png')));
    sampleData.add(new RadioModel(false, FaceCard(text: 'Square', path: 'assets/icons/square.png')));
    sampleData.add(new RadioModel(false, FaceCard(text: 'Oval', path: 'assets/icons/oval.png')));
    sampleData.add(new RadioModel(false, FaceCard(text: 'Heart', path: 'assets/icons/heart.png')));
    sampleData.add(new RadioModel(false, FaceCard(text: 'Long', path: 'assets/icons/long.png')));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text("ListItem"),
      // ),

      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 30.0,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        children:
          List.generate(
            sampleData.length,
            (index) => Center
            (
              child: InkWell(
                splashColor: Colors.blueAccent,
                onTap: () {
                  setState(() {
                    sampleData.forEach((element) => element.isSelected = false);
                    sampleData[index].isSelected = true;
                  });
                },
                child: new RadioItem(sampleData[index]),
              )
            )
          )
      )
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  bool notNull(Object o) => o != null;
  
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(5.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          GestureDetector(
            child: new FaceCard(text: _item.faceCard.text, path: _item.faceCard.path,),
          ),
          _item.isSelected ? Icon(Icons.check, color: Colors.green):null
        ].where(notNull).toList(),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  FaceCard faceCard;

  RadioModel(this.isSelected, this.faceCard);
}