import 'package:html/dom.dart';
import 'package:oscrapper/core/utils.dart';

class OSElement {

  Element? _element;
  Map<String, String> _properties = Map();
  void set element(Element? element) => _element = element;
  Map<String, String> get properties => _properties;

  /**
   * Construtor padrão do OSElement
   *  - OSElement é uma classe que representa o
   * dado 'Element' da DOM
   */
  OSElement({Element? element}){
    if(!oseNull(element))
      _element = element;
  }

  /**
   * Pega uma propriedade específica do OSElement
   */
  String? getProperty(String property) => _element!.attributes[property];

  /**
   * Escolhe uma propriedade específica para
   * ser guardada no OSElement. 
   * (Pode ser retornada usando 'properties["propriedade escolhida"]')
   */
  void addProperty(String property){
    String? _property = _element!.attributes[property];
    if(!oseNull(_property))
      _properties[property] = _property!;
  }

  /**
   * retorna um elemento pela tag
   */
  OSElement? getElementByTagName(String tag, {List<String>? properties}){
    return executeOSFunction(
      onError: ()=>defaultMessageError(),
      callback: (){
        List<Element> elements = _element!.getElementsByTagName(tag);
        if(elements.isEmpty)
          return null;
        OSElement osElement = OSElement(element: elements[0]);
        populateProperties(properties, osElement);
        return osElement;
      }
    );
  }

  /**
   * retorna um elemento pela classe presente em
   * OSElement e a retorna.
   */
  OSElement? getElementByClassName(String className, {List<String>? properties}){
    return executeOSFunction(
      onError: ()=>defaultMessageError(),
      callback: (){
        List<Element> elements = _element!.getElementsByClassName(className);
        if(elements.isEmpty)
          return null;
        OSElement osElement = OSElement(element: elements[0]);
        populateProperties(properties, osElement);
        return osElement;
      }
    );

  }

  /**
   * retorna uma serie de elementos pela tag presente
   * no OSElement e a retorna 
   */
  List<OSElement> getElementsByTagName(String tag, {List<String>? properties}){
    return executeOSFunction(
      onError: ()=>defaultMessageError(),
      callback: (){
        List<OSElement> osElements = [];
        _element!.getElementsByTagName(tag).forEach((element) {
          OSElement osElement = OSElement(element: element);
          populateProperties(properties, osElement);
          osElements.add(osElement);
        });
        return osElements;
      }
    );
  }

  /**
   * retorna um elemento escolhido
   */
  OSElement? getElement(String query, {List<String>? properties}){
    return executeOSFunction(
      onError: ()=>defaultMessageError(),
      callback: (){
        Element? element = _element!.querySelector(query);
        if(oseNull(element))
          return null;
        OSElement osElement = OSElement(element: element);
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
      onError: ()=>defaultMessageError(),
      callback: (){
        List<OSElement> osElements = [];
        List<Element> elements = _element!.querySelectorAll(query);
        elements.forEach((element) {
          OSElement osElement = OSElement(element: element);
          populateProperties(properties, osElement);
          osElements.add(osElement);
        });    
        return osElements;  
      }
    );
  
  }

  List<String> getImagesUrl({bool dataSrc = false}){
    return executeOSFunction(
      onError: ()=>defaultMessageError(),
      callback: (){
        String property = dataSrc ? 'data-src' : 'src';
        List<String> urls = [];
        _element!.getElementsByTagName('img').forEach((element) {      
          String? _url = element.attributes[property];
          if(_url != null)
            urls.add(_url);
        });
        return urls;
      }
    );
  }

  /** texto do elemento */
  String get text => _element!.text;
  /** nome da classe do elemento */
  String get className => _element!.className;
  /** lista das classes do elemento */
  CssClassSet get classes => _element!.classes;
  /** id do do elemento */
  String get id => _element!.id;
  /** primeiro nodo filho do elemento */
  Node? get firstChild => _element!.firstChild;

  @override
  String toString() {
    String _tag;
    if(!oseNull(_element)){
      _tag = _element.toString();
      _tag = _tag.substring(1, _tag.length-1);
      _tag = _tag.split(' ')[1];
    }else{_tag = "invalid element";}

    String _toString = properties.isEmpty? "${_tag}" : "{ ${_tag}, ${properties} }";
    return _toString;
  }

}