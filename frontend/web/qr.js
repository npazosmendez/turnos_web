var video = document.createElement("video");
var noTick=true;
var codigoQR="vacío";

//window.onmessage(m, function() {});

function scan(){
    noTick=false;
    document.getElementById("lock").className="bkglock";
    document.getElementById("dialogo").className="dialog";
    
    var canvasElement = document.getElementById("canvas");
    var canvas = canvasElement.getContext("2d");
    var codigoQR="ninguno";
    
    function drawLine(begin, end, color) {
      canvas.beginPath();
      canvas.moveTo(begin.x, begin.y);
      canvas.lineTo(end.x, end.y);
      canvas.lineWidth = 4;
      canvas.strokeStyle = color;
      canvas.stroke();
    }

    navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } }).then(function(stream) {
      video.srcObject = stream;
      video.setAttribute("playsinline", true);
      video.play();
    
      requestAnimationFrame(tick);
    });

    setTimeout(5000, function(){
      return codigoQR;
    });

    function tick() {

      if (noTick) return "";
      
      if (video.readyState === video.HAVE_ENOUGH_DATA) {
        canvasElement.hidden = false;

        canvasElement.height = video.videoHeight;
        canvasElement.width = video.videoWidth;
        canvas.drawImage(video, 0, 0, canvasElement.width, canvasElement.height);
        var imageData = canvas.getImageData(0, 0, canvasElement.width -1, canvasElement.height -1);
        
        var code = jsQR(imageData.data, imageData.width, imageData.height, {
          inversionAttempts: "dontInvert",
        });

        if (code && code.data!="") {
          drawLine(code.location.topLeftCorner, code.location.topRightCorner, "#FF3B58");
          drawLine(code.location.topRightCorner, code.location.bottomRightCorner, "#FF3B58");
          drawLine(code.location.bottomRightCorner, code.location.bottomLeftCorner, "#FF3B58");
          drawLine(code.location.bottomLeftCorner, code.location.topLeftCorner, "#FF3B58");
         
          scanoff();
          postMessage(code.data,'*');
          codigoQR=code.data;
          return;
        } 
      }
      requestAnimationFrame(tick);
    }
}

function scanoff() {
  noTick=true;
  document.getElementById("dialogo").className="dialoginv";
  document.getElementById("lock").className="bkg";
  document.getElementById("canvas").hidden=true;
  if (video) {
    video.srcObject.getTracks().forEach(function(track) {
      track.stop();
   });
  }
}