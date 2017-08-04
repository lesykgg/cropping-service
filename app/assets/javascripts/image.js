function getImageCoords(event, img) {
    var rect = img.getBoundingClientRect();
    var posX = event.offsetX ? (event.offsetX) : event.pageX - img.offsetLeft;
    var posY = event.offsetY ? (event.offsetY) : event.pageY - img.offsetTop;
    var color = '#000000';
    var size = '10px';
    $("#point")
        .css('position', 'absolute')
        .css('top', posY - 5 + 'px')
        .css('left', posX - 5 + 'px')
        .css('width', size)
        .css('height', size)
        .css('background-color', color)
        .css('border-radius', '5px');
    var multiplier = $('#hidden_field').text();
    $('#point_x').val(parseInt(posX*multiplier));
    $('#point_y').val(parseInt(posY*multiplier));
}