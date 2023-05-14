import Masonry from "./masonry/masonry";

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
