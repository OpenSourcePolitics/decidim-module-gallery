import Masonry from "./masonry/masonry";

window.addGalleryHandlers = function () {
  $(".gallery-item > a").on("click", function(event){
    event.preventDefault();
    $(".gallery-item > a.gallery-item-active").removeClass("gallery-item-active");
    $(event.target).parent("a").addClass("gallery-item-active");

    $(".reveal").on("open.zf.reveal", function(){
      $(window).trigger('resize');
    });
    $(".reveal").on("closeme.zf.reveal", function(){
      let link = $(".gallery-item > a.gallery-item-active");
      let id = link.data("id");
      let chosenSlide = $("[data-target="+id+"]");
      let index = chosenSlide.index(".orbit-container > li");
      $('.orbit').foundation('changeSlide', true, chosenSlide, index);
      $(document).on("slidechange.zf.orbit", function (){
        $(window).trigger('resize');
      });
    });
  });
}

$(() => {
  $(".gallery img").one("load", function() {
    $('.gallery.image').masonry({
      itemSelector: '.gallery-item',
    });
  }).each(function() {
    if(this.complete) {
      $(this).trigger('load'); // For jQuery >= 3.0
    }
  });

  $(document).on('open.zf.reveal', '[data-reveal]', function () {
    $(window).trigger('resize');
  });

});

document.addEventListener("DOMContentLoaded", function(event) { addGalleryHandlers(); });
