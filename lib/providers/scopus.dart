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
    };
  }

  Future<void> clearData() async {
    authorId = '';
    orcid = '';
    createdDocuments = [];
    universityName = '';
    scopusProfileLink = '';
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
      //   'name': responseBody['search-results']['entry'][0]['preferred-name']
      //       ['given-name'],
      //   'surname': responseBody['search-results']['entry'][0]['preferred-name']
      //       ['surname'],
      'authorId': responseBody['search-results']['entry'][0]['dc:identifier']
          .toString()
          .substring(responseBody['search-results']['entry'][0]['dc:identifier']
                  .toString()
                  .indexOf(':') +
              1),
      'orcid': responseBody['search-results']['entry'][0]['orcid'],
      'univeristyName': responseBody['search-results']['entry'][0]
          ['affiliation-current']['affiliation-name'],
      //   'amount_of_documents': responseBody['search-results']['entry'][0]
      //       ['document-count'],
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
      'query': 'AU-ID($authorScopusId)'
    };
    final urlToReq = await Helpers().changeUrlToRequest(url);
    final finalUrl = await Uri.https(urlToReq[0], urlToReq[1], queryParameters);
    final response = await http.get(finalUrl, headers: queryParameters);
    final responseBody = jsonDecode(response.body);
    final dataToReturn = <Map<String, String>>[];
    for (var i = 0;
        i <
            int.parse(
                responseBody['search-results']['opensearch:totalResults']);
        i++) {
      await dataToReturn.add({
        'title': responseBody['search-results']['entry'][i]['dc:title'],
        'creator': responseBody['search-results']['entry'][i]['dc:creator'],
        'publicationName': responseBody['search-results']['entry'][i]
            ['prism:publicationName'],
        'dateOfCreation': responseBody['search-results']['entry'][i]
            ['prism:coverDisplayDate'],
        'citedByCount': responseBody['search-results']['entry'][i]
            ['citedby-count'],
        'link': responseBody['search-results']['entry'][i]['link'][2]['@href'],
      });
    }
    createdDocuments = dataToReturn;
    return dataToReturn;
  }

  Future<dynamic> returnAuthorRetrieval(String authorScopusId) async {
    var url =
        'https://api.elsevier.com/content/author/author_id/$authorScopusId';
    var queryParameters = await {
      'httpAccept': 'application/json',
      'apiKey': Constants.apiKeyScoupus,
      'insttoken': Constants.instTokenScoupus,
    };
    final urlToReq = await Helpers().changeUrlToRequest(url);
    final finalUrl = await Uri.https(urlToReq[0], urlToReq[1], queryParameters);
    final response = await http.get(finalUrl, headers: queryParameters);
    print(response.body);
    jsonDecode(response.body);
  }
//  AUTHOR ID
//   final authorScoupusID = responseData['search-results']['entry'][0]
//             ['dc:identifier']
//         .toString()
//         .substring(responseData['search-results']['entry'][0]['dc:identifier']
//                 .toString()
//                 .indexOf(':') +
//             1);

// Important data
// authorScopusId, orcid,eid, amount of documents, cited by count, citation count,data about univeristy(name,address)
  Future<dynamic> returnAuthorRetrival(String authorScopusId) async {
    const url = 'https://api.elsevier.com/content/author';
    var queryParameters = await {
      'httpAccept': 'application/json',
      'apiKey': Constants.apiKeyScoupus,
      'insttoken': Constants.instTokenScoupus,
      'author_id': '$authorScopusId'
    };
    final urlToReq = await Helpers().changeUrlToRequest(url);
    final finalUrl = await Uri.https(urlToReq[0], urlToReq[1], queryParameters);
    final response = await http.get(finalUrl, headers: queryParameters);
    print(response.body);
    return jsonDecode(response.body);
  }

  //nothing new
  Future<dynamic> returnAbstractRetrieval(String authorScopusId) async {
    var url =
        'https://api.elsevier.com/content/abstract/scopus_id/$authorScopusId';
    var queryParameters = await {
      'httpAccept': 'application/json',
      'apiKey': Constants.apiKeyScoupus,
      'insttoken': Constants.instTokenScoupus,
      // 'author_id': '$authorScopusId'
    };
    final urlToReq = await Helpers().changeUrlToRequest(url);
    final finalUrl = await Uri.https(urlToReq[0], urlToReq[1], queryParameters);
    final response = await http.get(finalUrl, headers: queryParameters);
    print(response.body);
    return jsonDecode(response.body);
  }
}
