import 'package:oscrapper/core/oselement.dart';

class Logger {
  
  static void log(String msg){
    print('[SCRAPPER] $msg');
  }

  static void logError(String msg,{String? msgError}){
    if(msgError == null)
      print('[SCRAPPER_ERROR] $msg');
    else
      print('[SCRAPPER_ERROR] $msg\n\t-[$msgError]');
  }

}

void populateProperties(List<String>? properties, OSElement? osElement){
  if(properties != null && osElement != null){
    properties.forEach((property) {
      osElement.addProperty(property);
    });
  }
}

/**
  verifica se 'target' é nulo
*/
bool oseNull(dynamic target) => target == null;

dynamic executeOSFunction({
  required dynamic onError,
  required dynamic callback,
  bool validation = true
}){
  if(!validation)
    return null;
  dynamic result = callback();
  if(!oseNull(result))
    return result;
  onError();
  return null;  
}

void defaultMessageError({String? msg, String? msgError}){
  if(!oseNull(msg))
    Logger.logError(msg!, msgError: msgError);
  else
    Logger.logError("Error!");
}