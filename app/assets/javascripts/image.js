function movePoint(x, y) {
    const color = '#000000';
    const size = '10px';
    $("#point")
        .css('position', 'absolute')
        .css('top', y + 'px')
        .css('left', x + 'px')
        .css('width', size)
        .css('height', size)
        .css('background-color', color)
        .css('border-radius', '5px');

}

function getImageCoords(event, img) {
    // const rect = img.getBoundingClientRect();
    const posX = event.offsetX ? (event.offsetX) : event.pageX - img.offsetLeft;
    const posY = event.offsetY ? (event.offsetY) : event.pageY - img.offsetTop;

    movePoint(posX - 5, posY - 5);

    const multiplier = $('#hidden_field').text();
    $('#point_x').val(parseInt(posX * multiplier));
    $('#point_y').val(parseInt(posY * multiplier));
}

$(document).ready(function() {
    $('#point_x, #point_y').on('input', function() {
        const multiplier = $('#hidden_field').text();
        const x = $('#point_x').val() / multiplier;
        const y = $('#point_y').val() / multiplier;

        movePoint(x - 5, y - 5);
    });
});
