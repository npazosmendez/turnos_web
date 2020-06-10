function whatsapp(port,mensaje,htmlFile){
    var prot = window.location.protocol;
    var host = window.location.hostname;
    var result = prot + "//" + host + ":" + port + "/tmp/" + encodeURIComponent(htmlFile);
    window.open("http://web.whatsapp.com/send?text="+mensaje+result,"compartirwhatsapp");
}