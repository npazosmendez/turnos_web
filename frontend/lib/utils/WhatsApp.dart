import 'dart:html';
import 'package:flutter/foundation.dart' show kIsWeb;

class WhatsappService {

  void compartir(String port, String mensaje, String htmlFile){
    var protocolo = window.location.protocol;
    var host = window.location.hostname;
    Uri shareurl;

    if (kIsWeb){
      shareurl = Uri.parse("http://web.whatsapp.com/send");
    } else {
      shareurl = Uri.parse("whatsapp://send");
    }

    if (port == "0") {
      port=":" + window.location.port.toString();
    } else if (port != "") {
      port=":" + port;
    } else {
      port="";
    }

    var mensaje_completo = mensaje +
        protocolo + "//" + host + port + "/tmp/" + Uri.encodeComponent(htmlFile);
    shareurl = shareurl.replace(queryParameters: {"text": mensaje_completo});
    
    AnchorElement a=document.getElementById("whatsapp");
    a.href=shareurl.toString();
    a.click();
    
  }
}