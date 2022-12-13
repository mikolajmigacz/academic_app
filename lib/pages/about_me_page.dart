import 'package:academic_app/providers/about_me.dart';
import 'package:academic_app/widgets/new_section_about_me.dart';
import 'package:academic_app/widgets/new_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scopus.dart';
import '../providers/user_data.dart';
import '../shared/constants.dart';
import '../widgets/app_drawer.dart';

class AboutMePage extends StatefulWidget {
  static String routeName = '/about_me';
  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserData>(context);
    var scopusData = Provider.of<Scopus>(context);
    var aboutMeData = Provider.of<AboutMe>(context);
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Image.asset(
            "assets/images/logo.png",
            width: 75,
            height: 75,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/profile.png",
                  width: 150,
                  height: 150,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Dane',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InfoRow('Imie i Nazwisko:',
                  '${userData.firstName} ${userData.surname}'),
              InfoRow('Uczelnia:', '${scopusData.universityName}'),
              InfoRow('Scopus ID:', '${scopusData.authorId}'),
              InfoRow('ORCID:', '${scopusData.orcid}'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Tytuły naukowe',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ((aboutMeData.inz != '') && (aboutMeData.inz != null))
                  ? InfoRow('Inżynier:', aboutMeData.inz)
                  : AddTitle(context, 'inżyniera'),
              ((aboutMeData.inz == '') || (aboutMeData.inz == null))
                  ? SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : ((aboutMeData.mgr != '') && (aboutMeData.mgr != null))
                      ? InfoRow('Magister:', aboutMeData.mgr)
                      : AddTitle(context, 'magistra'),
              ((aboutMeData.mgr == '') || (aboutMeData.mgr == null))
                  ? SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : ((aboutMeData.hab != '') && (aboutMeData.hab != null))
                      ? InfoRow('Habilitacja:', aboutMeData.hab)
                      : AddTitle(context, 'habilitacji'),
              ((aboutMeData.hab == '') || (aboutMeData.hab == null))
                  ? SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : ((aboutMeData.prof != '') && (aboutMeData.prof != null))
                      ? InfoRow('Profesor:', aboutMeData.prof)
                      : AddTitle(context, 'profesora'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Edukacja',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ((aboutMeData.education != '') && (aboutMeData.education != null))
                  ? Text(
                      aboutMeData.education,
                      maxLines: 20,
                    )
                  : AddSection(context, 'edukacji'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Działalność naukowa i zainteresowania',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ((aboutMeData.description != '') &&
                      (aboutMeData.description != null))
                  ? Text(
                      aboutMeData.description,
                      maxLines: 20,
                    )
                  : AddSection(
                      context, 'działalności naukowej i zainteresowań'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Doświadczenie zawodowe',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ((aboutMeData.experience != '') &&
                      (aboutMeData.experience != null))
                  ? Text(
                      aboutMeData.experience,
                      maxLines: 20,
                    )
                  : AddSection(context, 'doświadczenia zawodowego'),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }

  Widget AddTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text("Dodaj tytuł ${title}"),
        SizedBox(
          width: 5,
        ),
        IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) {
                  return GestureDetector(
                    onTap: () {},
                    child: Center(child: NewTitle(title)),
                    behavior: HitTestBehavior.opaque,
                  );
                },
              );
              setState(() {});
            },
            icon: Icon(
              Icons.add,
              color: Constants.primaryColor,
            )),
      ]),
    );
  }

  Widget AddSection(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text("Dodaj opis ${title}"),
        SizedBox(
          width: 5,
        ),
        IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) {
                  return GestureDetector(
                    onTap: () {},
                    child: Center(child: NewSection(title)),
                    behavior: HitTestBehavior.opaque,
                  );
                },
              );
              setState(() {});
            },
            icon: Icon(
              Icons.add,
              color: Constants.primaryColor,
            )),
      ]),
    );
  }
}

Widget InfoRow(String main, String data) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          main,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          data,
        ),
      ],
    ),
  );
}
