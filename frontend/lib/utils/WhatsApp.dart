import 'dart:html';

class WhatsappService {
  Uri shareurl = Uri.parse("http://web.whatsapp.com/send");


  void compartir(String port, String mensaje, String htmlFile){
    var protocolo = window.location.protocol;
    var host = window.location.hostname;
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
    window.open(shareurl.toString(),"compartirwhatsapp");
  }
}