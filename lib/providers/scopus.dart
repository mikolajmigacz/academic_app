import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../shared/constants.dart';
import './helpers.dart';

class Scopus with ChangeNotifier {
  String authorId;
  String eid;
  String orcid;
  //lista map<tytul dokumentu : liczba cytacji"
  List<Map<String, int>> createDocuments;
  String universityName;

  // SCOPUS API FUNCTIONS

  //Important data :
  // author_id , eid, orcid, name, surname, document count, univeristy name, univeristy id, university city, university country
  Future<dynamic> returnScoupusAuthorDataRequest(
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
    return jsonDecode(response.body);
  }

  //Important data :
  //name of every document, number of citations for each document,
  Future<dynamic> returnScoupsSearch(String authorScopusId) async {
    const url = 'https://api.elsevier.com/content/search/scopus';
    var queryParameters = await {
      'apiKey': Constants.apiKeyScoupus,
      'insttoken': Constants.instTokenScoupus,
      'query': 'AU-ID($authorScopusId)'
    };
    final urlToReq = await Helpers().changeUrlToRequest(url);
    final finalUrl = await Uri.https(urlToReq[0], urlToReq[1], queryParameters);
    final response = await http.get(finalUrl, headers: queryParameters);
    print(response.body);
    return jsonDecode(response.body);
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
    return jsonDecode(response.body);
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
