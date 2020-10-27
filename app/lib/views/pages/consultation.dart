import 'package:app/widgets/preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Consultation extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          title: Text(
        'Consultation',
        style: TextStyle(fontFamily: 'Klavika'),
      )),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/consultation_top.svg',
                  semanticsLabel: 'My account',
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                Text(
                  'Consultation',
                  style: Theme.of(context).textTheme.headline1,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                Text(
                  'Texture',
                  style: Theme.of(context).textTheme.headline2,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Preview(
                                    assetPath:
                                        'assets/consultation/texture_chart.jpg',
                                  )));
                    },
                    child: Image.asset(
                      'assets/consultation/texture_chart.jpg',
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                InkWell(
                  onTap: () => launch(
                      'http://site.marquesahair.com/home/marquesas-hair-texture-chart/'),
                  child: Text('Source',
                      style: TextStyle(
                          fontFamily: 'Klavika',
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 124, 62, 233),
                          fontWeight: FontWeight.w700)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Preview(
                                    assetPath:
                                        'assets/consultation/texture_chart_2.jpg',
                                  )));
                    },
                    child: Image.asset(
                      'assets/consultation/texture_chart_2.jpg',
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                InkWell(
                  onTap: () => launch(
                      'https://shilpaahuja.com/natural-hair-types-hair-texture-chart/'),
                  child: Text('Source',
                      style: TextStyle(
                          fontFamily: 'Klavika',
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 124, 62, 233),
                          fontWeight: FontWeight.w700)),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                Text(
                  'Porosity',
                  style: Theme.of(context).textTheme.headline2,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Preview(
                                    assetPath:
                                        'assets/consultation/porosity_1.jpg',
                                  )));
                    },
                    child: Image.asset(
                      'assets/consultation/porosity_1.jpg',
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                InkWell(
                  onTap: () => launch(
                      'https://www.pinterest.com.au/pin/334110866098422834/?nic_v2=1a6wqtca0'),
                  child: Text('Source',
                      style: TextStyle(
                          fontFamily: 'Klavika',
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 124, 62, 233),
                          fontWeight: FontWeight.w700)),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Preview(
                                    assetPath:
                                        'assets/consultation/porosity_2.jpg',
                                  )));
                    },
                    child: Image.asset(
                      'assets/consultation/porosity_2.jpg',
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                InkWell(
                  onTap: () => launch('https://curls.biz/hair-type-guide/'),
                  child: Text('Source',
                      style: TextStyle(
                          fontFamily: 'Klavika',
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 124, 62, 233),
                          fontWeight: FontWeight.w700)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                ),
                Text(
                  'Density',
                  style: Theme.of(context).textTheme.headline2,
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Preview(
                                    assetPath:
                                        'assets/consultation/density_1.jpg',
                                  )));
                    },
                    child: Image.asset(
                      'assets/consultation/density_1.jpg',
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                InkWell(
                    onTap: () => launch(
                        'https://www.facebook.com/LapeppoWigAcademy/photos/a-hair-density-is-the-amount-of-hair-strands-on-the-head-generally-it-is-measure/2953297281393374/'),
                    child: Text('Source',
                        style: TextStyle(
                            fontFamily: 'Klavika',
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 124, 62, 233),
                            fontWeight: FontWeight.w700))),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Preview(
                                    assetPath:
                                        'assets/consultation/density_2.jpg',
                                  )));
                    },
                    child: Image.asset(
                      'assets/consultation/density_2.jpg',
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                InkWell(
                    onTap: () => launch(
                        'https://www.finelacewigs.com/content/22-density-Chart?id_appagebuilder_profiles=7'),
                    child: Text('Source',
                        style: TextStyle(
                            fontFamily: 'Klavika',
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 124, 62, 233),
                            fontWeight: FontWeight.w700))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
