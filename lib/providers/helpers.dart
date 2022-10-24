class Helpers {
  List<String> changeUrlToRequest(String url) {
    String mainUrl = '';
    String restOfUrl = '';
    final tabOfUrl = url.split('/');
    bool flag = false;
    for (String element in tabOfUrl) {
      if (flag) {
        restOfUrl += element + '/';
      }
      if (element.contains('com') || element.contains('pl')) {
        mainUrl = element;
        flag = true;
      }
    }
    return [mainUrl, restOfUrl];
  }
}
