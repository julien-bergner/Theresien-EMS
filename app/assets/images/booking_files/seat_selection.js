
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
    document.getElementById("textausgabe2").innerHTML=txt;
    for (var i = 0; i < numberOfTables; i++)
    {
        if(i==0) { tickettype = "Flanierkarte";}
        else if (i >= 11) { tickettype = "Emporenkarte"; }
        else {tickettype = "Platzkarte";}

        if(i==0)
        {
            if (selectedSeats[i] == 1)
            {
                if(txt == "&nbsp;")
                {txt = txt + selectedSeats[i] + " " +  tickettype ;}
                else
                {txt = txt + "<br>" + selectedSeats[i] + " " + tickettype ;}

            }
            else if (selectedSeats[i] > 1)
            {
                if(txt == "&nbsp;")
                {txt = txt + selectedSeats[i] + " " + tickettype + "n" ;}
                else
                {txt = txt + "<br>" + selectedSeats[i] + " " + tickettype + "n" ;}

            }

        }





        else {
            if (selectedSeats[i] == 1)
            {
                if(txt == "&nbsp;")
                {txt = txt + selectedSeats[i] + " " +  tickettype + " an Tisch " + parseInt(i) ;}
                else
                {txt = txt + "<br>" + selectedSeats[i] + " " + tickettype + " an Tisch " + parseInt(i) ;}

            }
            else if (selectedSeats[i] > 1)
            {
                if(txt == "&nbsp;")
                {txt = txt + selectedSeats[i] + " " + tickettype + "n" + " an Tisch " + parseInt(i) ;}
                else
                {txt = txt + "<br>" + selectedSeats[i] + " " + tickettype + "n" + " an Tisch " + parseInt(i) ;}

            }
        }
    }

    document.getElementById("textausgabe1").innerHTML=txt;
    document.getElementById("textausgabe2").innerHTML=txt;


}
;
