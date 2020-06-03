var video = document.createElement("video");
function scan(){
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
          
          postMessage(code.data,'*');
          scanoff();
        } 
      }
      requestAnimationFrame(tick);
    }
}

function scanoff() {
  document.getElementById("dialogo").className="dialoginv";
  document.getElementById("lock").className="bkg";
  document.getElementById("canvas").hidden=true;
  if (video) {
    video.srcObject.getTracks().forEach(function(track) {
      track.stop();
   });
  }
}