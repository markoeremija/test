/*$(document).ready(function(){
    $("click").click(function(){
        $("div").animate({top: '250px'});
    });
});*/


$(document).ready(function(){
    $("button").click(function(){
        $("div").animate({
            height: 'toggle'
        });
    });
});

/*$(document).ready(function(){
    $(".shapes").mouseenter(function(){
        $(".shapes").slideUp("slow");
    });
});*/
/*$(document).ready(function(){
    $("#p1").mouseenter(function(){
        alert("You entered p1!");
    });
});*/

$(window).scroll(function() {

    if ($(this).scrollTop()>0)
     {
        $('.shapes').slideUp("very slow");
     }
    else
     {
      $('.shapes').slideDown("very very slow");
     }
 });
$(window).scroll(function() {

    if ($(this).scrollTop()>0)
     {
        $('.logo').slideUp("very slow");
     }
    else
     {
      $('.logo').slideDown("very very slow");
     }
 });

/*var angle = 0;
  setInterval(function(){
    angle+=3;
  $(".rotate lemon").rotate(angle);
  },50);*/
/*  var angle = 0;
  setInterval(function(){
    angle+=3;
  $(".rotate waves").rotate(angle);
  },50);*/

 

 var angle = 0;
setInterval(function(){
      angle+=1;
     $("#waves").rotate(angle);
},50);

var angle = 0;
setInterval(function(){
      angle+=1;
     $("#lemon").rotate(angle);
},50);


/*$("#waves").rotate({bind:{
  click: function(){
    $(this).rotate({
      duration:6000,
      angle: 0,
      animateTo:100
      })
    }
  }
});*/
/*var myIndex = 0;
carousel();*/

/*function carousel() {
    var i;
    var x = document.getElementsByClassName("mySlides");
    for (i = 0; i < x.length; i++) {
       x[i].style.display = "none";
    }
    myIndex++;
    if (myIndex > x.length) {myIndex = 1}
    x[myIndex-1].style.display = "block";
    setTimeout(carousel, 2000); // Change image every 2 seconds
}*/
/*var slideIndex = 1;
showDivs(slideIndex);

function plusDivs(n) {
  showDivs(slideIndex += n);
}

function currentDiv(n) {
  showDivs(slideIndex = n);
}

function showDivs(n) {
  var i;
  var x = document.getElementsByClassName("slikeKlizanje");
  var dots = document.getElementsByClassName("demo");
  if (n > x.length) {slideIndex = 1}
  if (n < 1) {slideIndex = x.length}
  for (i = 0; i < x.length; i++) {
     x[i].style.display = "none";
  }
  for (i = 0; i < dots.length; i++) {
     dots[i].className = dots[i].className.replace(" w3-white", "");
  }
  x[slideIndex-1].style.display = "block";
  dots[slideIndex-1].className += " w3-white";
}*/


$("#slideshow > div:gt(0)").hide();

var index = 1;
var maxindex = $('#slideshow > div').length;

setInterval(function () {
    $('#slideshow > div:first')
        .fadeOut(3000)
        .next()
        .fadeIn(3000)
        .end()
        .appendTo('#slideshow');
    $('ul li').removeClass('active');
    $('ul li:eq(' + index + ')').addClass('active');
    index = index < maxindex - 1 ? index + 1 : 0;
}, 3000);

for (var i = 0; i < maxindex; i++) {
    $('ul').append('<li class="' + (i == 0 ? 'active' : '') + '"></li>');
}
