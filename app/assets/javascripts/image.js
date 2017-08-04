function getImageCoords(event, img) {
    var rect = img.getBoundingClientRect();
    var posX = event.offsetX ? (event.offsetX) : event.pageX - img.offsetLeft;
    var posY = event.offsetY ? (event.offsetY) : event.pageY - img.offsetTop;

    movePoint(posX - 5, posY - 5);

    var multiplier = $('#hidden_field').text();
    $('#point_x').val(parseInt(posX*multiplier));
    $('#point_y').val(parseInt(posY*multiplier));
}

function movePoint(x, y) {
    var color = '#000000';
    var size = '10px';
    $("#point")
        .css('position', 'absolute')
        .css('top', y + 'px')
        .css('left', x + 'px')
        .css('width', size)
        .css('height', size)
        .css('background-color', color)
        .css('border-radius', '5px');

}

$(document).ready(function() {
    $('#point_x, #point_y').on('input', function() {
        var multiplier = $('#hidden_field').text();
        const x = $('#point_x').val() / multiplier;
        const y = $('#point_y').val() / multiplier;
        movePoint(x - 5, y - 5);
    });
});
