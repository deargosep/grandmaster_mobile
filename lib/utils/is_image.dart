bool isImage(String url) {
  RegExp reg = RegExp(
      r"(?:([^:/?#]+):)?(?://([^/?#]*))?([^?#]*\.(?:jpg|gif|png))(?:\?([^#]*))?(?:#(.*))?",
      caseSensitive: false);
  return reg.hasMatch(url);
}
