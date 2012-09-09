

var numberOfTables = 16;



$(function(){
    $(".seat").click(function() {
        var img = $(this);

        ManageSelection(img, name);

       });
});

$(function(){
    $("#next-button").click(function() {
        var bool = false;
        for (var i = 1; i <= numberOfTables; i++)
        {
            if(tableLists[i-1] > 0) {bool = true};
        }
        if(bool == false) alert("Bitte wählen Sie mindestens einen Platz aus den Sie buchen möchten!");

    });
});


function ManageSelection(img)
{
    var name = img.attr('name');
    var id = img.attr('id');
    var parts = name.split('?');
    if (parts[0] == "occupied")
        alert('Dieser Platz ist bereits vergeben. Bitte wählen Sie einen anderen Platz aus!');
    else if (parts[0] == "reserved")
        alert('Dieser Platz ist bereits reserviert. Bitte wählen Sie einen anderen Platz aus!');
    else if (parts[0] == "unoccupied")
    {
        img.attr('src', '/assets/selected.png');
        var newName = 'selected' + '?' + parts[1];
        img.attr('name', newName);
        addToSelectedSeatsList(id);
        addSeatToTableList(parseInt(parts[1]));
        writeTextOutput();
        writeSelectedSeatsList();

    }
    else if (parts[0] == "selected")
    {
        img.attr('src', '/assets/unoccupied.png');
        var unoccupied = 'unoccupied' + '?' + parts[1];
        img.attr('name', unoccupied)
        removeFromSelectedSeatsList(id)
        removeSeatFromTableList(parseInt(parts[1]));
        writeTextOutput();
        writeSelectedSeatsList();




    }
    updateButton();

}

function updateButton() {


            var bool = false;
            for (var i = 1; i <= numberOfTables; i++)
            {
                if(tableLists[i-1] > 0) {bool = true};
            }
            if(bool == false) $("#next-button").attr('disabled', 'true');
            else $("#next-button").removeAttr('disabled');




}

function addSeatToTableList(num)
{
    tableLists[num] = tableLists[num] + 1;

}

function removeSeatFromTableList(num)
{
    tableLists[num] = tableLists[num] - 1;
}

function writeTextOutput()
{
    var text = "";
    var tickettype = "";

    for (var i = 0; i < numberOfTables; i++)
    {
        if(i==0) { tickettype = "Flanierkarte";}

        else {tickettype = "Platzkarte";}

        if(i==0)
        {
            if (tableLists[i] == 1)
            {
                if(text == "")
                {text = text + tableLists[i] + " " +  tickettype ;}
                else
                {text = text + "<br>" +  tableLists[i] + " " + tickettype ;}

            }
            else if (tableLists[i] > 1)
            {
                if(text == "")
                {text = text + tableLists[i] + " " + tickettype + "n" ;}
                else
                {text = text + "<br>"  + tableLists[i] + " " + tickettype + "n" ;}

            }

        }





        else {
            if (tableLists[i] == 1)
            {
                if(text == "")
                {text = text + tableLists[i] + " " +  tickettype + " an Tisch " + parseInt(i) ;}
                else
                {text = text + "<br>" + tableLists[i] + " " + tickettype + " an Tisch " + parseInt(i) ;}

            }
            else if (tableLists[i] > 1)
            {
                if(text == "")
                {text = text + tableLists[i] + " " + tickettype + "n" + " an Tisch " + parseInt(i) ;}
                else
                {text = text + "<br>" + tableLists[i] + " " + tickettype + "n" + " an Tisch " + parseInt(i) ;}

            }
        }
    }

    $("#textoutput").html(text);






}

function addToSelectedSeatsList(seat) {
    if(jQuery.inArray(selectedSeatsArray, seat) == -1) selectedSeatsArray.push(seat);

}

function removeFromSelectedSeatsList(seat) {

        selectedSeatsArray = jQuery.grep(selectedSeatsArray, function(value) {
            return value != seat;
        });


}


function writeSelectedSeatsList() {
    var selectedSeatsField = $("#selectedSeatsList");
    selectedSeatsField.attr('value', selectedSeatsArray.toString());
}

jQuery(document).ready(function($) {
    writeTextOutput();
    writeSelectedSeatsList();
    updateButton();

});