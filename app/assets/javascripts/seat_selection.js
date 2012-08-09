
$(function(){
    $(".seat").click(function() {
        var img = $(this);

        ManageSelection(img, name);

       });
});


function ManageSelection(img)
{
    var name = img.attr('name');
    if (name == "occupied")
        alert('Dieser Platz ist bereits vergeben. Bitte wählen Sie einen anderen Platz aus!');
    else if (name == "reserved")
        alert('Dieser Platz ist bereits reserviert. Bitte wählen Sie einen anderen Platz aus!');
    else if (name == "unoccupied")
    {
        img.attr('src', '/assets/selected.png');
        img.attr('name', 'selected');

    }
    else if (name == "selected")
    {
        img.attr('src', '/assets/unoccupied.png');
        img.attr('name', 'unoccupied')




    }

}