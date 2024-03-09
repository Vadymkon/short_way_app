class Query {
  late final String apiURL;
  Map<String,dynamic> parameters = {};
  late final String method;

  Query(this.apiURL,this.parameters, this.method){}

  Query.withQuery(String query, this.method)
  {
    //zab.com?since_id=12345&max_id=54321
    query = query.trim();  //comfortness safety
    apiURL = query.split('?')[0];

    //get parameters
    if (query.contains('?')) {
      query.replaceFirst('$apiURL?', '');
      query.split('&').forEach((element) { //foreach parametr
        final List<String> buffer_el = element.split('='); //split it by =
        parameters[buffer_el[0]] = buffer_el[1]; //add new parametr
      });
    }
  }
}