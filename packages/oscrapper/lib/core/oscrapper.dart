library oscrapper;

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:oscrapper/core/oselement.dart';
import 'package:oscrapper/core/utils.dart';

class OScrapper {

  // default url 
  String? _baseUrl;
  // response 
  Document? _document;

  /*
    exemplo : items_per_page -> "10"
    url..?items_per_page=10...
  */
  Map<String, String>? _parameters;

  /** define a url padrão */
  set baseUrl(String baseUrl) => _baseUrl = baseUrl; 

  /** validação do document */
  bool _documentValidation(){
    bool _temp = oseNull(_document);
    if(_temp)Logger.logError('document is null!');
    return !_temp;
  } 
  
  /** retorna a url baseada na opção de rota/sem rota */
  String _getBaseUrl(String? route) => oseNull(route) ? _baseUrl! : "$_baseUrl$route";
  
  /** retorna os parametros em formato de query para a url */
  String _getParametersQuery(){
    String _query = "";
    // controle de filtros
    int _paramIndex = 0;
    _parameters!.entries.forEach((param){          
      if(_paramIndex == 0)
        _query = "?${param.key}=${param.value}";
      else 
        _query += "&${param.key}=${param.value}";
      _paramIndex++;
    });    
    return _query;
  }


  /**
    Cria a conexão entre o 'baseUrl' e retorna 
    um document valido para a manipulação
  */
  Future<bool> open({
    String? baseUrl,
    String? route,
    Map<String, String>? parameters,
    bool hasParameters = false
  }) async {

    if(oseNull(_baseUrl) && oseNull(baseUrl)){
      Logger.log("set the target url before call open!");
      return false;
    }

    if(!oseNull(baseUrl))
      _baseUrl = baseUrl;
    if(!oseNull(parameters))
      _parameters = parameters!;

    try {
      
      // controle do parametro de rota
      String _url = _getBaseUrl(route);
      // Controle de parametros de url 
      if(hasParameters && !oseNull(_parameters))
        _url += _getParametersQuery();        
      Uri url = Uri.parse(_url);
      print(url);
      http.Response response = await http.get(url); 

      switch (response.statusCode) {
        case 200:{
          _document = parse(response.body);                  
          return true;
        }
        default:{
          Logger.log('response status code ${response.statusCode}.');
          return false;
        }
      }
   

    } catch (e) {
      Logger.logError('the response failed!', msgError: e.toString());
      return false;
    }

  }

  /**
   * retorna um elemento escolhido
  */
  OSElement? getElement(String query, {List<String>? properties}){
    return executeOSFunction(
      validation: _documentValidation(),
      onError: ()=>print("Deu erro borde"),
      callback: (){
        OSElement? osElement;
        Element? element = _document!.querySelector(query);
        osElement = OSElement(element: element); 
        populateProperties(properties, osElement);      
        return osElement;
      }
    );
  }

  /**
  * retorna uma serie de elementos do tipo OSElement
  */
  List<OSElement> getElements(String query, {List<String>? properties}){
    return executeOSFunction(
      validation: _documentValidation(),
      onError: ()=>print("Errorr"),
      callback: (){
        List<OSElement> osElements = [];
        List<Element> elements = _document!.querySelectorAll(query);
        elements.forEach((element) {
          OSElement osElement = OSElement(element: element);
          populateProperties(properties, osElement);
          osElements.add(osElement);
        });
        return osElements;   
      }
    );
  }

}


