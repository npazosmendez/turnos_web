var video = document.createElement("video");
var noTick=true;

function scan() {
    noTick=false;
    document.getElementById("lock").className="bkglock";
    document.getElementById("dialogo").className="dialog";
    
    var canvasElement = document.getElementById("canvas");
    var canvas = canvasElement.getContext("2d");
    
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

    function tick() {

      if (noTick) return "";
      
      if (video.readyState === video.HAVE_ENOUGH_DATA) {
        
        factor=video.videoHeight/video.videoWidth;

        canvasElement.width = window.innerWidth/2;
        canvasElement.height = canvasElement.width*factor;
        canvasElement.hidden = false;

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
         
          scanoff(code.data);
          return;
        } 
      }
      requestAnimationFrame(tick);
    }
}

function scanoff(data) {
  noTick=true;
  postMessage(data,'*');
  document.getElementById("dialogo").className="dialoginv";
  document.getElementById("lock").className="bkg";
  canvas.width+=0;
  document.getElementById("canvas").hidden=true;
  if (video) {
    video.srcObject.getTracks().forEach(function(track) {
      track.stop();
   });
  }
}