import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../shared/constants.dart';
import './helpers.dart';

class Scopus with ChangeNotifier {
  String authorId;
  String orcid;
  //lista map<tytul dokumentu : ...itd."
  List<Map<String, String>> createdDocuments = [];
  String universityName;
  String scopusProfileLink;
  int hirischIndex;
  int citationSummary = 0;

  Scopus(
      {this.authorId,
      this.orcid,
      this.scopusProfileLink,
      this.createdDocuments,
      this.universityName});

  // receiving data from server
  factory Scopus.fromMap(map) {
    return Scopus(
        authorId: map['authorId'],
        orcid: map['orcid'],
        scopusProfileLink: map['scopusProfileLink'],
        universityName: map['universityName'],
        createdDocuments: map['createdDocuments'] as List<Map<String, String>>);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'orcid': orcid,
      'scopusProfileLink': scopusProfileLink,
      'createdDocuments': createdDocuments,
      'universityName': universityName,
      'hirischIndex': hirischIndex.toString(),
    };
  }

  Future<void> calculateHirischIndex() async {
    List helperList = [];
    for (var document in createdDocuments) {
      helperList.add(int.parse(document['citedByCount']));
    }
    helperList.sort((b, a) => a.compareTo(b));
    for (var i = 0; i < helperList.length; i++) {
      if (helperList[i] <= i + 1) {
        hirischIndex = helperList[i];
        return;
      }
    }
  }

  Future<void> caluclateCitationsAmount() async {
    for (var document in createdDocuments) {
      citationSummary += int.parse(document['citedByCount']);
    }
  }

  Future<void> clearData() async {
    authorId = '';
    orcid = '';
    createdDocuments = [];
    universityName = '';
    scopusProfileLink = '';
    hirischIndex = 0;
    citationSummary = 0;
  }
  // SCOPUS API FUNCTIONS

  //Important data :
  // author_id , eid, orcid, name, surname, document count, univeristy name, univeristy id, university city, university country
  Future<Map<String, dynamic>> returnScoupusAuthorDataRequest(
      String firstName, String lastName, String city) async {
    const url = 'https://api.elsevier.com/content/search/author';
    var queryParameters = await {
      'apiKey': Constants.apiKeyScoupus,
      'insttoken': Constants.instTokenScoupus,
      'count': '1',
      'query':
          'AFFIL($city and agh) AND AUTHFIRST($firstName) AND AUTHLASTNAME($lastName)'
    };
    final urlToReq = await Helpers().changeUrlToRequest(url);
    final finalUrl = await Uri.https(urlToReq[0], urlToReq[1], queryParameters);
    final response = await http.get(finalUrl, headers: queryParameters);

    final responseBody = jsonDecode(response.body);
    final dataToReturn = <String, String>{
      'authorId': responseBody['search-results']['entry'][0]['dc:identifier']
          .toString()
          .substring(responseBody['search-results']['entry'][0]['dc:identifier']
                  .toString()
                  .indexOf(':') +
              1),
      'orcid': responseBody['search-results']['entry'][0]['orcid'],
      'univeristyName': responseBody['search-results']['entry'][0]
          ['affiliation-current']['affiliation-name'],
      'scopusProfileLink': responseBody['search-results']['entry'][0]['link'][3]
          ['@href'],
    };
    authorId = dataToReturn['authorId'];
    orcid = dataToReturn['orcid'];
    universityName = dataToReturn['univeristyName'];
    scopusProfileLink = dataToReturn['scopusProfileLink'];
    return dataToReturn;
  }

  //Important data :
  //name of every document, number of citations for each document,
  Future<List<Map<String, dynamic>>> returnScoupsSearch(
      String authorScopusId) async {
    const url = 'https://api.elsevier.com/content/search/scopus';
    var queryParameters = await {
      'apiKey': Constants.apiKeyScoupus,
      'insttoken': Constants.instTokenScoupus,
      'query': 'AU-ID($authorScopusId)',
      // 'start': '24'
    };
    final urlToReq = await Helpers().changeUrlToRequest(url);
    var finalUrl = await Uri.https(urlToReq[0], urlToReq[1], queryParameters);
    var response = await http.get(finalUrl, headers: queryParameters);
    var responseBody = jsonDecode(response.body);
    final dataToReturn = <Map<String, String>>[];
    int totalResults =
        int.parse(responseBody['search-results']['opensearch:totalResults']);
    if (totalResults > 25) {
      for (var i = 0; i < (totalResults / 25).ceil(); i++) {
        queryParameters['start'] = (i * 25).toString();
        var finalUrl =
            await Uri.https(urlToReq[0], urlToReq[1], queryParameters);
        var response = await http.get(finalUrl, headers: queryParameters);
        var responseBody = jsonDecode(response.body);
        int totalToFor;
        if (i != ((totalResults / 25).ceil() - 1)) {
          totalToFor = 25;
        } else {
          totalToFor = totalResults - (i * 25);
        }
        for (var i = 0; i < totalToFor; i++) {
          await dataToReturn.add({
            'title': responseBody['search-results']['entry'][i]['dc:title'],
            'creator': responseBody['search-results']['entry'][i]['dc:creator'],
            'publicationName': responseBody['search-results']['entry'][i]
                ['prism:publicationName'],
            'dateOfCreation': responseBody['search-results']['entry'][i]
                ['prism:coverDisplayDate'],
            'citedByCount': responseBody['search-results']['entry'][i]
                ['citedby-count'],
            'link': responseBody['search-results']['entry'][i]['link'][2]
                ['@href'],
          });
        }
      }
    } else {
      for (var i = 0; i < totalResults; i++) {
        await dataToReturn.add({
          'title': responseBody['search-results']['entry'][i]['dc:title'],
          'creator': responseBody['search-results']['entry'][i]['dc:creator'],
          'publicationName': responseBody['search-results']['entry'][i]
              ['prism:publicationName'],
          'dateOfCreation': responseBody['search-results']['entry'][i]
              ['prism:coverDisplayDate'],
          'citedByCount': responseBody['search-results']['entry'][i]
              ['citedby-count'],
          'link': responseBody['search-results']['entry'][i]['link'][2]
              ['@href'],
        });
      }
    }

    createdDocuments = dataToReturn;
    return dataToReturn;
  }
}
