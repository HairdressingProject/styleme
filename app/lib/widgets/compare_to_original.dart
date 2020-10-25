import 'package:app/services/constants.dart';
import 'package:app/widgets/comparison_picture.dart';
import 'package:flutter/material.dart';

class CompareToOriginal extends StatefulWidget {
  final String originalPictureUrl;
  final String currentPictureUrl;
  final String origin;
  final String userToken;

  const CompareToOriginal({
    Key key,
    @required this.originalPictureUrl,
    @required this.currentPictureUrl,
    this.origin = ADMIN_PORTAL_URL,
    @required this.userToken,
  }) : super(key: key);

  @override
  _CompareToOriginalState createState() => _CompareToOriginalState();
}

class _CompareToOriginalState extends State<CompareToOriginal> {
  bool _sideBySide = true;

  void _onViewChanged(bool newValue) {
    setState(() {
      _sideBySide = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 96, 96, 96),
        appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close),
            ),
            title: Text(
              'Your changes so far',
              style: TextStyle(fontFamily: 'Klavika', letterSpacing: 0.8),
            )),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Text(
                          _sideBySide ? 'Side by side' : 'Stacked',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Klavika',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        ),
                        Switch(value: _sideBySide, onChanged: _onViewChanged),
                      ],
                    ),
                  )
                ],
              ),
              _sideBySide
                  ? Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                        ),
                        ComparisonPicture(
                            title: 'Original',
                            pictureUrl: widget.originalPictureUrl,
                            userToken: widget.userToken),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                        ),
                        ComparisonPicture(
                            title: 'Current',
                            pictureUrl: widget.currentPictureUrl,
                            userToken: widget.userToken),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                        ),
                      ],
                    )
                  : Expanded(
                      child: Scrollbar(
                        child: GridView.count(
                          crossAxisCount: 1,
                          mainAxisSpacing: 20.0,
                          children: [
                            ComparisonPicture(
                              title: 'Original',
                              pictureUrl: widget.originalPictureUrl,
                              userToken: widget.userToken,
                              sideBySide: false,
                            ),
                            ComparisonPicture(
                              title: 'Current',
                              pictureUrl: widget.currentPictureUrl,
                              userToken: widget.userToken,
                              sideBySide: false,
                            )
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ));
  }
}
