import 'dart:html' as html;
import 'dart:async';
import 'dart:typed_data';

class PickedFile {
  final String name;
  final Uint8List data;

  const PickedFile(this.name, this.data);

  static Future<PickedFile> promptUser(String acceptType) {
    // html usa callbacks en vez de Futures. Con el Completer lo transformamos a un Future.
    var completer = new Completer<PickedFile>();

    // Creamos un Input de html para archivos
    var uploadInput = html.FileUploadInputElement();
    uploadInput.accept = acceptType;
    uploadInput.onChange.listen((e) {

      if (uploadInput.files.length == 0){
        completer.completeError(new Exception("No se encontraron archivos."));
        return;
      }

      // Habemus archivo, intentemos leerlo
      final file = uploadInput.files[0];
      var reader =  html.FileReader();
      reader.onLoadEnd.listen((e) async {
        var pickledFile = PickedFile(file.name, reader.result);
        completer.complete(pickledFile);
      });
      reader.onError.listen((e) {
        completer.completeError(new Exception("Error leyendo el archivo."));
      });

      reader.readAsArrayBuffer(file);
    });

    // Trigger Input
    uploadInput.click();

    return completer.future;
  }
}
