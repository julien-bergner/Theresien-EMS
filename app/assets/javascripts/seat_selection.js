
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
            if(selectedSeats[i-1] > 0) {bool = true};
        }
        if(bool == true)
           $(this).attr('name', "selectedSeats=" + JSON.stringify( selectedSeats ));
        else
            alert("Bitte wählen Sie mindestens einen Platz aus den Sie reservieren möchten!");

    });
});


function ManageSelection(img)
{
    var name = img.attr('name');
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
        AddSeat(parseInt(parts[1]));
        writeText();

    }
    else if (parts[0] == "selected")
    {
        img.attr('src', '/assets/unoccupied.png');
        var unoccupied = 'unoccupied' + '?' + parts[1];
        img.attr('name', unoccupied)
        RemoveSeat(parseInt(parts[1]));
        writeText();




    }

}

var selectedSeats = new Array();
var numberOfTables = 16;

//initialize selectedSeats array
for (var i = 0; i < numberOfTables; i++)
{
    selectedSeats.unshift(0);
}

function AddSeat(num)
{
    selectedSeats[num] = selectedSeats[num] + 1;
}

function RemoveSeat(num)
{
    selectedSeats[num] = selectedSeats[num] - 1;
}

function writeText()
{
    var txt = "&nbsp;";
    var tickettype = "";
    document.getElementById("textausgabe1").innerHTML=txt;

    for (var i = 0; i < numberOfTables; i++)
    {
        if(i==0) { tickettype = "Flanierkarte";}

        else {tickettype = "Platzkarte";}

        if(i==0)
        {
            if (selectedSeats[i] == 1)
            {
                if(txt == "&nbsp;")
                {txt = txt + selectedSeats[i] + " " +  tickettype ;}
                else
                {txt = txt + "<br>" + "&nbsp;" + selectedSeats[i] + " " + tickettype ;}

            }
            else if (selectedSeats[i] > 1)
            {
                if(txt == "&nbsp;")
                {txt = txt + selectedSeats[i] + " " + tickettype + "n" ;}
                else
                {txt = txt + "<br>" + "&nbsp;" + selectedSeats[i] + " " + tickettype + "n" ;}

            }

        }





        else {
            if (selectedSeats[i] == 1)
            {
                if(txt == "&nbsp;")
                {txt = txt + selectedSeats[i] + " " +  tickettype + " an Tisch " + parseInt(i) ;}
                else
                {txt = txt + "<br>" + "&nbsp;" + selectedSeats[i] + " " + tickettype + " an Tisch " + parseInt(i) ;}

            }
            else if (selectedSeats[i] > 1)
            {
                if(txt == "&nbsp;")
                {txt = txt + selectedSeats[i] + " " + tickettype + "n" + " an Tisch " + parseInt(i) ;}
                else
                {txt = txt + "<br>" + "&nbsp;" + selectedSeats[i] + " " + tickettype + "n" + " an Tisch " + parseInt(i) ;}

            }
        }
    }

    document.getElementById("textausgabe1").innerHTML=txt;



}